package catalog

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestInstallInfoForManifestRoot(t *testing.T) {
	dir := t.TempDir()
	if err := os.WriteFile(filepath.Join(dir, "manifest.json"), []byte(`{"root_directory":"Release"}`), 0o644); err != nil {
		t.Fatal(err)
	}
	got := InstallInfoForPath(dir, GitHubLocation{Owner: "Ezandora", Repo: "Example"}, "Release/relay/example.ash")
	if !got.Available {
		t.Fatalf("expected installable path: %+v", got)
	}
	if got.Checkout != "git checkout https://github.com/Ezandora/Example.git" {
		t.Fatalf("checkout = %q", got.Checkout)
	}
	if got.Delete != "git delete Ezandora-Example" {
		t.Fatalf("delete = %q", got.Delete)
	}
}

func TestInstallInfoRejectsSourceTreeASH(t *testing.T) {
	got := InstallInfoForPath(t.TempDir(), GitHubLocation{Owner: "C2Talon", Repo: "kolmafia"}, "src/relay/example.ash")
	if got.Available {
		t.Fatalf("source-tree .ash must not advertise direct checkout: %+v", got)
	}
	if !strings.Contains(got.Reason, "does not expose") {
		t.Fatalf("expected explanatory reason, got %q", got.Reason)
	}
}

func TestClassifyAndDescribe(t *testing.T) {
	k := KeywordSet{Key: []string{"inventory", "mall", "profit"}}
	class, desc := ClassifyAndDescribe("Networth", "value / inventory", k, Behavior{Class: "read-mostly"})
	if class != "value / inventory" {
		t.Fatalf("class = %q", class)
	}
	for _, want := range []string{"Networth", "inventory", "read-mostly"} {
		if !strings.Contains(desc, want) {
			t.Fatalf("description missing %q: %q", want, desc)
		}
	}
}
