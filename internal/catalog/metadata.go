package catalog

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

var kolmafiaPermissibleRoots = map[string]bool{
	"scripts": true,
	"data": true,
	"images": true,
	"relay": true,
	"ccs": true,
	"planting": true,
}

// InstallInfoForPath emits KoLmafia gCLI commands only when the archived file
// is actually under a directory KoLmafia's GitManager will synchronize.
// This avoids telling users to checkout source repositories whose .ash files
// merely happen to exist somewhere in a Java/source tree.
func InstallInfoForPath(repoDir string, loc GitHubLocation, repositoryPath string) InstallInfo {
	rel := strings.Trim(strings.ReplaceAll(filepath.ToSlash(repositoryPath), "\\", "/"), "/")
	root := manifestRootDirectory(repoDir)
	if root != "" {
		prefix := strings.Trim(root, "/") + "/"
		if !strings.HasPrefix(rel, prefix) {
			return InstallInfo{Reason: "This archived file is outside the KoLmafia manifest root and is not advertised as a direct Git install."}
		}
		rel = strings.TrimPrefix(rel, prefix)
	}
	parts := strings.Split(rel, "/")
	if len(parts) < 2 || !kolmafiaPermissibleRoots[parts[0]] {
		return InstallInfo{Reason: "Repository layout does not expose this file through a KoLmafia Git permissible folder (scripts/data/images/relay/ccs/planting)."}
	}
	projectID := loc.Owner + "-" + loc.Repo
	repoURL := loc.RepoURL() + ".git"
	return InstallInfo{
		Available: true,
		Checkout:  "git checkout " + repoURL,
		Delete:    "git delete " + projectID,
		ProjectID: projectID,
	}
}

func manifestRootDirectory(repoDir string) string {
	b, err := os.ReadFile(filepath.Join(repoDir, "manifest.json"))
	if err != nil {
		return ""
	}
	var m struct {
		RootDirectory string `json:"root_directory"`
	}
	if json.Unmarshal(b, &m) != nil {
		return ""
	}
	root := strings.Trim(strings.ReplaceAll(filepath.ToSlash(m.RootDirectory), "\\", "/"), "/")
	if root == "" || strings.HasPrefix(root, ".") || strings.Contains(root, "..") {
		return ""
	}
	return root
}

func ClassifyAndDescribe(title, sourceCategory string, keywords KeywordSet, behavior Behavior) (string, string) {
	classification := strings.TrimSpace(sourceCategory)
	if classification == "" {
		classification = "general ASH automation"
		if len(keywords.Key) > 0 {
			classification = keywords.Key[0] + " / ASH automation"
		}
	}
	focus := "general KoLmafia automation"
	if len(keywords.Key) > 0 {
		focus = strings.Join(keywords.Key, ", ")
	}
	description := fmt.Sprintf(
		"%s is cataloged as %s. Indexed focus: %s. Static behavior classification: %s.",
		title, classification, focus, behavior.Class,
	)
	return classification, description
}
