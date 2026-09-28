package catalog

import (
	"fmt"
	"sort"
	"strings"
	"unicode"
)

type RecordGroup struct {
	Name    string
	Records []Record
}

func GroupRecords(records []Record, key func(Record) string) []RecordGroup {
	m := map[string][]Record{}
	for _, r := range records {
		k := strings.TrimSpace(key(r))
		if k == "" {
			k = "Unknown"
		}
		m[k] = append(m[k], r)
	}
	names := make([]string, 0, len(m))
	for k := range m {
		names = append(names, k)
	}
	sort.Slice(names, func(i, j int) bool { return strings.ToLower(names[i]) < strings.ToLower(names[j]) })
	out := make([]RecordGroup, 0, len(names))
	for _, name := range names {
		rs := m[name]
		sort.Slice(rs, func(i, j int) bool { return strings.ToLower(rs[i].Title) < strings.ToLower(rs[j].Title) })
		out = append(out, RecordGroup{Name: name, Records: rs})
	}
	return out
}

func GroupsAZ(records []Record) []RecordGroup {
	return GroupRecords(records, func(r Record) string {
		for _, ch := range r.Title {
			if unicode.IsLetter(ch) || unicode.IsDigit(ch) {
				return strings.ToUpper(string(ch))
			}
		}
		return "#"
	})
}
func GroupsClassification(records []Record) []RecordGroup {
	return GroupRecords(records, func(r Record) string { return r.Classification })
}
func GroupsSource(records []Record) []RecordGroup {
	return GroupRecords(records, func(r Record) string {
		return strings.TrimPrefix(r.RepositoryURL, "https://github.com/")
	})
}
func GroupsAuthor(records []Record) []RecordGroup {
	return GroupRecords(records, func(r Record) string {
		if r.Author != "" { return r.Author }
		if r.Player != "" { return r.Player }
		return "Unknown"
	})
}
func GroupsYear(records []Record) []RecordGroup {
	return GroupRecords(records, func(r Record) string {
		if r.Year == 0 { return "Year unknown" }
		return fmt.Sprintf("%d", r.Year)
	})
}
