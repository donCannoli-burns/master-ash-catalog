package catalog

import (
	"bufio"
	"crypto/sha256"
	"fmt"
	"os"
	"regexp"
	"sort"
	"strconv"
	"strings"
)

var (
	reAuthor  = regexp.MustCompile(`(?im)^\\s*(?://+|#|/\\*|\\*)?\\s*(?:created\\s+by|author\\s*[:=])\\s*([A-Za-z0-9_. '()-]{2,60})\\s*$`)
	reNotify  = regexp.MustCompile(`(?i)//\s*notify\s+["']?([^"';]+)`)
	reVersion = regexp.MustCompile(`(?i)\bversion\s*[:=]?\s*([0-9][0-9A-Za-z._-]*)`)
	reYear    = regexp.MustCompile(`\b(19[89][0-9]|20[0-3][0-9])\b`)
	reURL     = regexp.MustCompile(`https?://[^\s"'<>]+`)
	reFunc    = regexp.MustCompile(`(?m)^\s*(?:boolean|int|float|string|buffer|item|location|familiar|monster|effect|skill|record|void|matcher|aggregate|class|stat|element|slot|path|phylum|coinmaster)\s+([A-Za-z_][A-Za-z0-9_]*)\s*\(`)
	reImport  = regexp.MustCompile(`(?m)^\s*import\s*[<"]([^>"]+)[>"]`)
)

func AnalyzeFile(path string) (author string, player string, year int, version, provenance string, functions, imports []string, hash string, size int64, content string, err error) {
	b, err := os.ReadFile(path)
	if err != nil {
		return "", "", 0, "", "", nil, nil, "", 0, "", err
	}
	sum := sha256.Sum256(b)
	hash = fmt.Sprintf("%x", sum[:])
	size = int64(len(b))
	content = string(b)
	s := bufio.NewScanner(strings.NewReader(content))
	var head []string
	for len(head) < 240 && s.Scan() {
		head = append(head, s.Text())
	}
	header := strings.Join(head, "\n")
	if m := reAuthor.FindStringSubmatch(header); len(m) > 1 {
		author = cleanName(m[1])
	}
	if m := reNotify.FindStringSubmatch(header); len(m) > 1 && author == "" {
		author = cleanName(m[1])
	}
	if author != "" {
		player = author
	}
	if m := reVersion.FindStringSubmatch(header); len(m) > 1 {
		version = m[1]
	}
	bestYear := 9999
	for _, line := range head {
		lc := strings.ToLower(line)
		if !(strings.Contains(lc, "copyright") || strings.Contains(lc, "created") || strings.Contains(lc, "release") || strings.Contains(lc, "version") || strings.Contains(lc, "updated") || strings.Contains(lc, "date")) {
			continue
		}
		for _, y := range reYear.FindAllString(line, -1) {
			n, _ := strconv.Atoi(y)
			if n < bestYear {
				bestYear = n
			}
		}
	}
	if bestYear != 9999 {
		year = bestYear
	}

	if u := reURL.FindString(header); u != "" {
		provenance = strings.TrimRight(u, ").,;]")
	}
	functions = uniqueMatches(content, reFunc)
	imports = uniqueMatches(content, reImport)
	return
}

func cleanName(s string) string {
	s = strings.TrimSpace(strings.Trim(s, "*/#;:-"))
	if i := strings.IndexAny(s, "\r\n"); i >= 0 {
		s = s[:i]
	}
	if len(s) > 80 {
		s = s[:80]
	}
	return strings.TrimSpace(s)
}

func uniqueMatches(content string, re *regexp.Regexp) []string {
	m := re.FindAllStringSubmatch(content, -1)
	seen := map[string]bool{}
	out := []string{}
	for _, x := range m {
		if len(x) > 1 && !seen[x[1]] {
			seen[x[1]] = true
			out = append(out, x[1])
		}
	}
	sort.Strings(out)
	return out
}
