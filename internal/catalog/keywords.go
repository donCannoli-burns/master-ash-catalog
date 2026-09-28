package catalog

import (
	"net/url"
	"regexp"
	"sort"
	"strings"
	"unicode"
)

var wordRE = regexp.MustCompile(`[A-Za-z][A-Za-z0-9'_-]*`)
var generic = map[string]bool{"ash": true, "script": true, "scripts": true, "lib": true, "library": true, "helper": true, "helpers": true, "main": true, "master": true, "test": true, "beta": true, "lite": true, "relay": true, "kol": true, "kolmafia": true}
var keywordStopwords = map[string]bool{
	"a": true, "an": true, "and": true, "are": true, "at": true, "by": true, "do": true,
	"for": true, "from": true, "get": true, "in": true, "into": true, "is": true, "main": true,
	"of": true, "on": true, "or": true, "set": true, "the": true, "to": true, "with": true,
	"ash": true, "script": true, "scripts": true, "lib": true, "library": true, "helper": true,
	"helpers": true, "master": true, "test": true, "beta": true, "lite": true, "kol": true,
	"kolmafia": true, "generate": true, "init": true, "initialise": true, "list": true,
	"new": true, "print": true, "custom": true, "help": true, "status": true, "total": true,
}
var behaviorSignals = []struct {
	Name    string
	Needles []string
	Weight  int
}{
	{"social-or-clan", []string{"send_kmail(", "chat_private(", "chat_clan(", "stash_take(", "stash_put("}, 5},
	{"adventuring", []string{"adventure(", "adv1(", "run_combat(", "attack("}, 4},
	{"purchasing", []string{"buy(", "retrieve_item(", "take_storage(", "autosell("}, 3},
	{"execution", []string{"cli_execute(", "visit_url("}, 2},
	{"preferences", []string{"set_property("}, 1},
}

func KeywordsFor(title, content, sourceCategory string, functions []string, seeds KeywordSeeds) KeywordSet {
	lc := strings.ToLower(title + " " + sourceCategory + " " + strings.Join(functions, " ") + " " + firstN(content, 12000))
	scores := map[string]int{}
	for _, key := range seeds.Primary {
		k := strings.ToLower(key)
		if strings.Contains(lc, k) {
			scores[k] += 8
		}
		for _, a := range seeds.Aliases[k] {
			if strings.Contains(lc, strings.ToLower(a)) {
				scores[k] += 4
			}
		}
	}
	for _, w := range tokenizeTitle(title) {
		scores[w] += 3
	}
	for _, f := range functions {
		for _, w := range tokenizeTitle(f) {
			scores[w]++
		}
	}
	ranked := rank(scores)
	key := fill(ranked, []string{"automation", "ash", "kolmafia"}, 3)
	sub := fill(excluding(ranked, key), []string{sourceCategory, "scripting", "utility", "workflow", "game-state", "reference"}, 6)
	meta := fill(excluding(ranked, append(key, sub...)), []string{"kingdom-of-loathing", "koLmafia", "ash-script", "automation", "community-script", "archive", "provenance", "source-code", "compatibility", "historical", "runtime", "reference"}, 12)
	return KeywordSet{Key: key, Sub: sub, Meta: meta}
}

func BehaviorFor(content string) Behavior {
	lc := strings.ToLower(content)
	signals := []string{}
	score := 0
	for _, s := range behaviorSignals {
		for _, n := range s.Needles {
			if strings.Contains(lc, n) {
				signals = append(signals, s.Name+":"+strings.TrimSuffix(n, "("))
				score += s.Weight
				break
			}
		}
	}
	class := "read-mostly"
	safe := "likely"
	if score >= 5 {
		class = "high-impact"
		safe = "unknown"
	} else if score >= 2 {
		class = "mutating"
		safe = "unknown"
	}
	// Crude top-level risk signal: mutation primitives in the first non-comment region.
	head := strings.ToLower(firstN(content, 5000))
	if (strings.Contains(head, "visit_url(") || strings.Contains(head, "set_property(") || strings.Contains(head, "cli_execute(")) && !strings.Contains(head, "void ") {
		safe = "unlikely"
	}
	return Behavior{Class: class, Signals: uniqueStrings(signals), ImportSafe: safe}
}

func WikiSearches(title string) []Link {
	var terms []string
	for _, w := range tokenizeTitle(title) {
		if len(w) >= 3 && !generic[w] {
			terms = append(terms, w)
		}
	}
	terms = uniqueStrings(terms)
	if len(terms) > 4 {
		terms = terms[:4]
	}
	out := []Link{}
	for _, t := range terms {
		q := url.QueryEscape(strings.ReplaceAll(t, "-", " "))
		out = append(out, Link{Name: "KoL Wiki: " + t, URL: "https://wiki.kingdomofloathing.com/Special:Search?search=" + q, Kind: "wiki-search"}, Link{Name: "KoLmafia Wiki: " + t, URL: "https://wiki.kolmafia.us/index.php?search=" + q, Kind: "wiki-search"})
	}
	return out
}

func tokenizeTitle(s string) []string {
	// split camel-case before lowercasing
	var b strings.Builder
	var prevLower bool
	for _, r := range s {
		if unicode.IsUpper(r) && prevLower {
			b.WriteByte(' ')
		}
		if unicode.IsLetter(r) || unicode.IsDigit(r) || r == '-' || r == '_' {
			b.WriteRune(r)
		} else {
			b.WriteByte(' ')
		}
		prevLower = unicode.IsLower(r)
	}
	ws := wordRE.FindAllString(strings.ToLower(b.String()), -1)
	out := []string{}
	for _, w := range ws {
		w = strings.Trim(w, "_-")
		if len(w) > 1 {
			out = append(out, w)
		}
	}
	return uniqueStrings(out)
}

func firstN(s string, n int) string {
	if len(s) <= n {
		return s
	}
	return s[:n]
}
func rank(m map[string]int) []string {
	type kv struct {
		k string
		v int
	}
	a := []kv{}
	for k, v := range m {
		if k != "" && !keywordStopwords[k] {
			a = append(a, kv{k, v})
		}
	}
	sort.Slice(a, func(i, j int) bool {
		if a[i].v == a[j].v {
			return a[i].k < a[j].k
		}
		return a[i].v > a[j].v
	})
	out := []string{}
	for _, x := range a {
		out = append(out, x.k)
	}
	return out
}
func excluding(in, ex []string) []string {
	m := map[string]bool{}
	for _, x := range ex {
		m[x] = true
	}
	out := []string{}
	for _, x := range in {
		if !m[x] {
			out = append(out, x)
		}
	}
	return out
}
func fill(in, fallback []string, n int) []string {
	out := uniqueStrings(in)
	for _, x := range fallback {
		if len(out) >= n {
			break
		}
		if x != "" && !contains(out, x) {
			out = append(out, x)
		}
	}
	if len(out) > n {
		out = out[:n]
	}
	return out
}
func contains(a []string, s string) bool {
	for _, x := range a {
		if x == s {
			return true
		}
	}
	return false
}
func uniqueStrings(a []string) []string {
	seen := map[string]bool{}
	out := []string{}
	for _, x := range a {
		x = strings.TrimSpace(x)
		if x != "" && !seen[x] {
			seen[x] = true
			out = append(out, x)
		}
	}
	return out
}
