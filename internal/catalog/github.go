package catalog

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"os"
	"path"
	"strings"
	"time"
)

type GitHubLocation struct {
	Owner string
	Repo  string
	Path  string
	Ref   string
}

func ParseGitHubURL(raw string) (GitHubLocation, error) {
	u, err := url.Parse(strings.TrimSpace(raw))
	if err != nil {
		return GitHubLocation{}, err
	}
	if u.Host != "github.com" && u.Host != "www.github.com" {
		return GitHubLocation{}, fmt.Errorf("not github.com: %s", raw)
	}
	parts := strings.Split(strings.Trim(u.Path, "/"), "/")
	if len(parts) < 1 || parts[0] == "" {
		return GitHubLocation{}, fmt.Errorf("missing GitHub owner: %s", raw)
	}
	loc := GitHubLocation{Owner: parts[0]}
	if len(parts) == 1 {
		return loc, nil
	}
	loc.Repo = strings.TrimSuffix(parts[1], ".git")
	if len(parts) >= 5 && (parts[2] == "blob" || parts[2] == "tree") {
		loc.Ref = parts[3]
		loc.Path = path.Clean(strings.Join(parts[4:], "/"))
	}
	return loc, nil
}

func (g GitHubLocation) RepoURL() string {
	if g.Owner == "" || g.Repo == "" {
		return ""
	}
	return "https://github.com/" + g.Owner + "/" + g.Repo
}

func DiscoverOwnerRepos(owner string, max int) ([]string, error) {
	if max <= 0 {
		max = 100
	}
	client := &http.Client{Timeout: 30 * time.Second}
	var out []string
	for page := 1; page <= 10 && len(out) < max; page++ {
		reqURL := fmt.Sprintf("https://api.github.com/users/%s/repos?per_page=100&page=%d&sort=updated", url.PathEscape(owner), page)
		req, _ := http.NewRequest(http.MethodGet, reqURL, nil)
		req.Header.Set("Accept", "application/vnd.github+json")
		req.Header.Set("User-Agent", "master-ash-catalog/ask-wiki")
		if tok := os.Getenv("GITHUB_TOKEN"); tok != "" {
			req.Header.Set("Authorization", "Bearer "+tok)
		}
		resp, err := client.Do(req)
		if err != nil {
			return out, err
		}
		body, rerr := io.ReadAll(io.LimitReader(resp.Body, 4<<20))
		resp.Body.Close()
		if rerr != nil {
			return out, rerr
		}
		if resp.StatusCode != http.StatusOK {
			return out, fmt.Errorf("github owner discovery %s: %s: %s", owner, resp.Status, strings.TrimSpace(string(body)))
		}
		var rows []struct {
			CloneURL string `json:"clone_url"`
			Fork     bool   `json:"fork"`
			Archived bool   `json:"archived"`
		}
		if err := json.Unmarshal(body, &rows); err != nil {
			return out, err
		}
		if len(rows) == 0 {
			break
		}
		for _, row := range rows {
			if row.Archived && row.Fork {
				continue
			}
			if row.CloneURL != "" {
				out = append(out, strings.TrimSuffix(row.CloneURL, ".git"))
			}
			if len(out) >= max {
				break
			}
		}
	}
	return out, nil
}
