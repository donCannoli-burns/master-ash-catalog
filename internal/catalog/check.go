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
		if _, err := os.Stat(filepath.Join(docsDir, "scripts", r.ID+".html")); err != nil {
			return fmt.Errorf("missing HTML companion for %s", r.ID)
		}
	}
	for _, name := range []string{"index.html", "credits.html", "official.html", "about.html", "assets/style.css", "assets/app.js", "assets/catalog.json"} {
		if _, err := os.Stat(filepath.Join(docsDir, name)); err != nil {
			return fmt.Errorf("missing generated artifact %s", name)
		}
	}
	return nil
}
