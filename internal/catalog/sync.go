package catalog

import (
	"encoding/json"
	"errors"
	"fmt"
	"io/fs"
	"os"
	"os/exec"
	"path/filepath"
	"sort"
	"strings"
	"time"
)

type SyncOptions struct{ ConfigPath, ArchiveDir, RecordsDir, CacheDir string }

type SyncReport struct {
	Sources             int `json:"sources"`
	Repositories        int `json:"repositories"`
	ScriptsVendored     int `json:"scripts_vendored"`
	BlockedRepositories int `json:"blocked_repositories"`
	Records             int `json:"records"`
}

func Sync(opts SyncOptions) (SyncReport, error) {
	cfg, err := LoadConfig(opts.ConfigPath)
	if err != nil {
		return SyncReport{}, err
	}
	for _, d := range []string{opts.ArchiveDir, opts.RecordsDir, opts.CacheDir} {
		if err := os.MkdirAll(d, 0o755); err != nil {
			return SyncReport{}, err
		}
	}
	repos := map[string][]Source{}
	for _, s := range cfg.Sources {
		if s.Kind == "github-owner" && s.Discover {
			loc, e := ParseGitHubURL(s.URL)
			if e != nil {
				return SyncReport{}, e
			}
			urls, e := DiscoverOwnerRepos(loc.Owner, s.MaxRepos)
			if e != nil {
				fmt.Fprintf(os.Stderr, "WARN owner discovery %s: %v\n", loc.Owner, e)
				continue
			}
			for _, u := range urls {
				copy := s
				copy.Kind = "repo"
				copy.URL = u
				copy.ID = s.ID + "--" + strings.ToLower(filepath.Base(u))
				repos[u] = append(repos[u], copy)
			}
			continue
		}
		if (s.Kind == "repo" || s.Kind == "file") && strings.Contains(s.URL, "github.com/") {
			loc, e := ParseGitHubURL(s.URL)
			if e == nil && loc.Repo != "" {
				repos[loc.RepoURL()] = append(repos[loc.RepoURL()], s)
			}
		}
	}
	keys := make([]string, 0, len(repos))
	for k := range repos {
		keys = append(keys, k)
	}
	sort.Strings(keys)
	report := SyncReport{Sources: len(cfg.Sources)}
	for _, repoURL := range keys {
		report.Repositories++
		if err := syncRepo(repoURL, repos[repoURL], cfg, opts, &report); err != nil {
			fmt.Fprintf(os.Stderr, "WARN sync %s: %v\n", repoURL, err)
		}
	}
	return report, nil
}

func syncRepo(repoURL string, sources []Source, cfg Config, opts SyncOptions, report *SyncReport) error {
	loc, err := ParseGitHubURL(repoURL)
	if err != nil {
		return err
	}
	dir := filepath.Join(opts.CacheDir, "repos", loc.Owner, loc.Repo)
	if err := os.MkdirAll(filepath.Dir(dir), 0o755); err != nil {
		return err
	}
	if _, err := os.Stat(filepath.Join(dir, ".git")); errors.Is(err, os.ErrNotExist) {
		if out, e := exec.Command("git", "clone", "--depth", "1", repoURL+".git", dir).CombinedOutput(); e != nil {
			return fmt.Errorf("git clone: %w: %s", e, strings.TrimSpace(string(out)))
		}
	} else {
		_ = exec.Command("git", "-C", dir, "fetch", "--depth", "1", "origin").Run()
		_ = exec.Command("git", "-C", dir, "reset", "--hard", "origin/HEAD").Run()
	}
	commit := strings.TrimSpace(run(dir, "rev-parse", "HEAD"))
	if commit == "" {
		return fmt.Errorf("cannot resolve commit")
	}
	license := DetectLicense(dir)
	if license.Status != "allowed" {
		report.BlockedRepositories++
		writeBlockedRecord(loc, sources, commit, license, opts)
		return nil
	}
	archiveRoot := filepath.Join(opts.ArchiveDir, safe(loc.Owner), safe(loc.Repo))
	if err := os.MkdirAll(archiveRoot, 0o755); err != nil {
		return err
	}
	copyLicense(dir, archiveRoot, &license)
	return filepath.WalkDir(dir, func(p string, d fs.DirEntry, e error) error {
		if e != nil {
			return e
		}
		if d.IsDir() {
			if d.Name() == ".git" {
				return filepath.SkipDir
			}
			return nil
		}
		if !strings.HasSuffix(strings.ToLower(d.Name()), ".ash") {
			return nil
		}
		rel, _ := filepath.Rel(dir, p)
		if !wantedPath(rel, sources) {
			return nil
		}
		dst := filepath.Join(archiveRoot, rel)
		if err := os.MkdirAll(filepath.Dir(dst), 0o755); err != nil {
			return err
		}
		b, err := os.ReadFile(p)
		if err != nil {
			return err
		}
		if err := os.WriteFile(dst, b, 0o644); err != nil {
			return err
		}
		author, player, year, version, prov, funcs, imports, hash, size, content, err := AnalyzeFile(p)
		if err != nil {
			return err
		}
		if author == "" {
			author = sources[0].Author
		}
		if player == "" {
			player = sources[0].Player
		}
		title := strings.TrimSuffix(filepath.Base(rel), filepath.Ext(rel))
		id := safe(strings.ToLower(loc.Owner + "--" + loc.Repo + "--" + strings.ReplaceAll(rel, string(filepath.Separator), "--")))
		lic := license
		lic.EvidenceURL = repoURL + "/blob/" + commit + "/" + license.EvidencePath
		lic.EvidencePath = filepath.ToSlash(filepath.Join("archive", safe(loc.Owner), safe(loc.Repo), "_source_license", filepath.Base(license.EvidencePath)))
		keywords := KeywordsFor(title, content, sources[0].Category, funcs, cfg.KeywordSeeds)
		behavior := BehaviorFor(content)
		classification, description := ClassifyAndDescribe(title, sources[0].Category, keywords, behavior)
		install := InstallInfoForPath(dir, loc, filepath.ToSlash(rel))
		rec := Record{ID: id, Title: title, ArchivePath: filepath.ToSlash(filepath.Join("archive", safe(loc.Owner), safe(loc.Repo), rel)), SourceID: sources[0].ID, SourceURL: sources[0].URL, RepositoryURL: repoURL, RepositoryPath: filepath.ToSlash(rel), Commit: commit, SHA256: hash, Bytes: size, Author: author, Player: player, Year: year, Version: version, ProvenanceURL: prov, License: lic, Classification: classification, Description: description, Install: install, Keywords: keywords, WikiSearches: WikiSearches(title), OfficialLinks: relevantOfficial(cfg.OfficialLinks, content, title), Behavior: behavior, Functions: funcs, Imports: imports, IndexedAt: time.Unix(0, 0).UTC()}
		if err := WriteJSON(filepath.Join(opts.RecordsDir, id+".json"), rec); err != nil {
			return err
		}
		report.ScriptsVendored++
		report.Records++
		return nil
	})
}

func wantedPath(rel string, sources []Source) bool {
	rel = filepath.ToSlash(rel)
	has := false
	for _, s := range sources {
		if len(s.Include) == 0 {
			continue
		}
		has = true
		for _, p := range s.Include {
			p = strings.TrimPrefix(filepath.ToSlash(p), "/")
			if strings.HasPrefix(rel, p) || matchSimple(p, rel) {
				return true
			}
		}
	}
	return !has
}
func matchSimple(pattern, name string) bool {
	if pattern == "**/*.ash" || pattern == "*.ash" {
		return strings.HasSuffix(strings.ToLower(name), ".ash")
	}
	return false
}
func run(dir string, args ...string) string {
	cmd := exec.Command("git", append([]string{"-C", dir}, args...)...)
	b, _ := cmd.Output()
	return string(b)
}
func safe(s string) string {
	s = strings.ToLower(s)
	var b strings.Builder
	dash := false
	for _, r := range s {
		ok := r >= 'a' && r <= 'z' || r >= '0' && r <= '9'
		if ok {
			b.WriteRune(r)
			dash = false
		} else if !dash {
			b.WriteByte('-')
			dash = true
		}
	}
	return strings.Trim(b.String(), "-")
}
func copyLicense(repo, root string, lic *License) {
	if lic.EvidencePath == "" {
		return
	}
	b, e := os.ReadFile(filepath.Join(repo, lic.EvidencePath))
	if e != nil {
		return
	}
	d := filepath.Join(root, "_source_license")
	_ = os.MkdirAll(d, 0o755)
	_ = os.WriteFile(filepath.Join(d, filepath.Base(lic.EvidencePath)), b, 0o644)
}
func writeBlockedRecord(loc GitHubLocation, s []Source, commit string, lic License, opts SyncOptions) {
	obj := map[string]any{"repository": loc.RepoURL(), "source_id": s[0].ID, "commit": commit, "license": lic, "status": "metadata-only; bytes not redistributed"}
	_ = WriteJSON(filepath.Join(opts.RecordsDir, "blocked--"+safe(loc.Owner+"--"+loc.Repo)+".json"), obj)
}
func relevantOfficial(links []Link, content, title string) []Link {
	lc := strings.ToLower(content + " " + title)
	out := []Link{}
	for _, l := range links {
		n := strings.ToLower(l.Name)
		if strings.Contains(n, "kolmafia forums") {
			out = append(out, l)
		} else if strings.Contains(lc, "clan") && strings.Contains(n, "kingdom of loathing") && !strings.Contains(n, "wiki") {
			out = append(out, l)
		}
	}
	if len(out) > 4 {
		out = out[:4]
	}
	return out
}

var _ = json.Valid
