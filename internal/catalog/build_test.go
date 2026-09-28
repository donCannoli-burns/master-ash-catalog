package catalog

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestScriptTemplateIncludesKnownProvenanceFields(t *testing.T) {
	out := filepath.Join(t.TempDir(), "script.html")
	r := Record{
		ID: "sample",
		Title: "Sample Script",
		RepositoryURL: "https://github.com/example/sample",
		RepositoryPath: "scripts/sample.ash",
		Commit: "abc123",
		SHA256: "0123456789abcdef",
		Author: "Example Author",
		Player: "ExamplePlayer",
		Year: 2009,
		Version: "1.2.3",
		ProvenanceURL: "https://example.invalid/provenance",
		License: License{Name: "MIT", Status: "allowed"},
		Behavior: Behavior{Class: "read-mostly", ImportSafe: "likely"},
	}
	if err := render(out, scriptTemplate, pageData{Config: Config{Name: "master-ash-catalog", UnofficialName: "ask-wiki"}, Record: r}); err != nil {
		t.Fatal(err)
	}
	b, err := os.ReadFile(out)
	if err != nil {
		t.Fatal(err)
	}
	got := string(b)
	for _, want := range []string{
		"<small>AUTHOR</small><strong>Example Author</strong>",
		"<small>PLAYER</small><strong>ExamplePlayer</strong>",
		"<small>YEAR</small><strong>2009</strong>",
		"<small>VERSION</small><strong>1.2.3</strong>",
		"<small>PROVENANCE</small><a href=\"https://example.invalid/provenance\">",
	} {
		if !strings.Contains(got, want) {
			t.Fatalf("generated page missing %q", want)
		}
	}
}
