package catalog

import "testing"

func TestKeywordsCardinality(t *testing.T) {
	s := KeywordSeeds{Primary: []string{"relay", "inventory", "combat"}, Aliases: map[string][]string{"relay": {"browser"}}}
	k := KeywordsFor("OCD Inventory.ash", "void main(){ visit_url(\"inventory.php\"); }", "item handling", []string{"main"}, s)
	if len(k.Key) != 3 || len(k.Sub) != 6 || len(k.Meta) != 12 {
		t.Fatalf("got %d/%d/%d", len(k.Key), len(k.Sub), len(k.Meta))
	}
}
func TestWikiSearches(t *testing.T) {
	x := WikiSearches("Source-Terminal-GUI")
	if len(x) == 0 {
		t.Fatal("expected noun searches")
	}
}
