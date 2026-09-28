package catalog

import (
	"os"
	"path/filepath"
	"testing"
)

func TestAnalyzeFileDoesNotTreatProseByAsAuthor(t *testing.T) {
	p := filepath.Join(t.TempDir(), "sample.ash")
	body := "// improve this by calling adventure.php directly with visit_url\nvoid main() {}\n"
	if err := os.WriteFile(p, []byte(body), 0o644); err != nil { t.Fatal(err) }
	author, _, year, _, _, _, _, _, _, _, err := AnalyzeFile(p)
	if err != nil { t.Fatal(err) }
	if author != "" { t.Fatalf("prose was misidentified as author: %q", author) }
	if year != 0 { t.Fatalf("unexpected year: %d", year) }
}

func TestAnalyzeFileReadsExplicitHeaderAuthorAndYear(t *testing.T) {
	p := filepath.Join(t.TempDir(), "sample.ash")
	body := "// Author: Example Player\n// Released: 2018-04-03\n// Version 1.2.3\nvoid main() {}\n"
	if err := os.WriteFile(p, []byte(body), 0o644); err != nil { t.Fatal(err) }
	author, player, year, version, _, _, _, _, _, _, err := AnalyzeFile(p)
	if err != nil { t.Fatal(err) }
	if author != "Example Player" || player != "Example Player" { t.Fatalf("author/player = %q/%q", author, player) }
	if year != 2018 { t.Fatalf("year = %d", year) }
	if version != "1.2.3" { t.Fatalf("version = %q", version) }
}
