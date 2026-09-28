package catalog

import "time"

type Config struct {
	Name           string       `json:"name"`
	UnofficialName string       `json:"unofficial_name"`
	Sources        []Source     `json:"sources"`
	OfficialLinks  []Link       `json:"official_links"`
	Credits        []Credit     `json:"credits"`
	KeywordSeeds   KeywordSeeds `json:"keyword_seeds"`
}

type Source struct {
	ID             string   `json:"id"`
	URL            string   `json:"url"`
	Kind           string   `json:"kind"` // repo, github-owner, file, forum, reference
	Category       string   `json:"category,omitempty"`
	Author         string   `json:"author,omitempty"`
	Player         string   `json:"player,omitempty"`
	Include        []string `json:"include,omitempty"`
	SpotlightPaths []string `json:"spotlight_paths,omitempty"`
	Discover       bool     `json:"discover,omitempty"`
	MaxRepos       int      `json:"max_repos,omitempty"`
	Notes          string   `json:"notes,omitempty"`
}

type Link struct {
	Name string `json:"name"`
	URL  string `json:"url"`
	Kind string `json:"kind,omitempty"`
}

type Credit struct {
	Name    string `json:"name"`
	Profile string `json:"profile"`
	Role    string `json:"role,omitempty"`
}

type KeywordSeeds struct {
	Primary []string            `json:"primary"`
	Aliases map[string][]string `json:"aliases"`
}

type Record struct {
	ID             string     `json:"id"`
	Title          string     `json:"title"`
	ArchivePath    string     `json:"archive_path"`
	SourceID       string     `json:"source_id"`
	SourceURL      string     `json:"source_url"`
	RepositoryURL  string     `json:"repository_url"`
	RepositoryPath string     `json:"repository_path"`
	Commit         string     `json:"commit"`
	SHA256         string     `json:"sha256"`
	Bytes          int64      `json:"bytes"`
	Author         string     `json:"author,omitempty"`
	Player         string     `json:"player,omitempty"`
	Year           int        `json:"year,omitempty"`
	Version        string     `json:"version,omitempty"`
	ProvenanceURL  string     `json:"provenance_url,omitempty"`
	License        License    `json:"license"`
	Keywords       KeywordSet `json:"keywords"`
	WikiSearches   []Link     `json:"wiki_searches,omitempty"`
	OfficialLinks  []Link     `json:"official_links,omitempty"`
	Behavior       Behavior   `json:"behavior"`
	Functions      []string   `json:"functions,omitempty"`
	Imports        []string   `json:"imports,omitempty"`
	IndexedAt      time.Time  `json:"indexed_at,omitempty"`
}

type License struct {
	Status       string `json:"status"` // allowed, blocked, review
	Name         string `json:"name,omitempty"`
	EvidencePath string `json:"evidence_path,omitempty"`
	EvidenceURL  string `json:"evidence_url,omitempty"`
	Reason       string `json:"reason,omitempty"`
}

type KeywordSet struct {
	Key  []string `json:"key"`
	Sub  []string `json:"sub"`
	Meta []string `json:"meta"`
}

type Behavior struct {
	Class      string   `json:"class"`
	Signals    []string `json:"signals,omitempty"`
	ImportSafe string   `json:"import_safe"` // likely, unknown, unlikely
}
