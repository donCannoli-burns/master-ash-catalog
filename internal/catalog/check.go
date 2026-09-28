package catalog

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

func Check(recordsDir, docsDir string) error {
	entries, err := os.ReadDir(recordsDir)
	if os.IsNotExist(err) {
		return nil
	}
	if err != nil {
		return err
	}
	for _, e := range entries {
		if e.IsDir() || !strings.HasSuffix(e.Name(), ".json") || strings.HasPrefix(e.Name(), "blocked--") {
			continue
		}
		b, err := os.ReadFile(filepath.Join(recordsDir, e.Name()))
		if err != nil {
			return err
		}
		var r Record
		if err := json.Unmarshal(b, &r); err != nil {
			return err
		}
		if r.ID == "" || r.SHA256 == "" {
			return fmt.Errorf("invalid record %s", e.Name())
		}
		if r.License.Status != "allowed" {
			return fmt.Errorf("vendored record %s is not license-allowed", r.ID)
		}
		if len(r.Keywords.Key) != 3 || len(r.Keywords.Sub) != 6 || len(r.Keywords.Meta) != 12 {
			return fmt.Errorf("keyword cardinality %s: %d/%d/%d", r.ID, len(r.Keywords.Key), len(r.Keywords.Sub), len(r.Keywords.Meta))
		}
		if strings.TrimSpace(r.Classification) == "" || strings.TrimSpace(r.Description) == "" {
			return fmt.Errorf("missing classification/description for %s", r.ID)
		}
		if r.Install.Available && (r.Install.Checkout == "" || r.Install.Delete == "" || r.Install.ProjectID == "") {
			return fmt.Errorf("incomplete install metadata for %s", r.ID)
		}
		pagePath := filepath.Join(docsDir, "scripts", r.ID+".html")
		page, err := os.ReadFile(pagePath)
		if err != nil {
			return fmt.Errorf("missing HTML companion for %s", r.ID)
		}
		pageText := string(page)
		if !strings.Contains(pageText, "../third-party.html") {
			return fmt.Errorf("script page %s missing third-party notice link", r.ID)
		}
		if r.Install.Available && (!strings.Contains(pageText, r.Install.Checkout) || !strings.Contains(pageText, r.Install.Delete)) {
			return fmt.Errorf("script page %s missing install/delete commands", r.ID)
		}
	}
	for _, name := range []string{"index.html", "az.html", "classifications.html", "sources.html", "authors.html", "years.html", "credits.html", "official.html", "about.html", "third-party.html", "license.html", "assets/style.css", "assets/app.js", "assets/catalog.json"} {
		path := filepath.Join(docsDir, name)
		if _, err := os.Stat(path); err != nil {
			return fmt.Errorf("missing generated artifact %s", name)
		}
		if strings.HasSuffix(name, ".html") {
			page, err := os.ReadFile(path)
			if err != nil {
				return err
			}
			if !strings.Contains(string(page), "third-party.html") {
				return fmt.Errorf("generated page %s missing third-party notice link", name)
			}
		}
	}
	return nil
}
