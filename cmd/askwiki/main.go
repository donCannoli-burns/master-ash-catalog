package main

import (
	"flag"
	"fmt"
	"github.com/donCannoli-burns/master-ash-catalog/internal/catalog"
	"os"
)

func main() {
	if len(os.Args) < 2 {
		usage()
		os.Exit(2)
	}
	switch os.Args[1] {
	case "sync":
		syncCmd(os.Args[2:])
	case "build":
		buildCmd(os.Args[2:])
	case "check":
		checkCmd(os.Args[2:])
	default:
		usage()
		os.Exit(2)
	}
}
func syncCmd(args []string) {
	fs := flag.NewFlagSet("sync", flag.ExitOnError)
	config := fs.String("config", "catalog/sources.json", "")
	archive := fs.String("archive", "archive", "")
	records := fs.String("records", "records", "")
	cache := fs.String("cache", ".cache/askwiki", "")
	_ = fs.Parse(args)
	r, err := catalog.Sync(catalog.SyncOptions{ConfigPath: *config, ArchiveDir: *archive, RecordsDir: *records, CacheDir: *cache})
	die(err)
	fmt.Printf("sync: sources=%d repositories=%d vendored=%d blocked=%d records=%d\n", r.Sources, r.Repositories, r.ScriptsVendored, r.BlockedRepositories, r.Records)
}
func buildCmd(args []string) {
	fs := flag.NewFlagSet("build", flag.ExitOnError)
	config := fs.String("config", "catalog/sources.json", "")
	archive := fs.String("archive", "archive", "")
	records := fs.String("records", "records", "")
	docs := fs.String("docs", "docs", "")
	_ = fs.Parse(args)
	die(catalog.Build(catalog.BuildOptions{ConfigPath: *config, ArchiveDir: *archive, RecordsDir: *records, DocsDir: *docs}))
	fmt.Println("build: docs ready")
}
func checkCmd(args []string) {
	fs := flag.NewFlagSet("check", flag.ExitOnError)
	records := fs.String("records", "records", "")
	docs := fs.String("docs", "docs", "")
	_ = fs.Parse(args)
	die(catalog.Check(*records, *docs))
	fmt.Println("check: PASS")
}
func usage() { fmt.Fprintln(os.Stderr, "askwiki <sync|build|check> [flags]") }
func die(err error) {
	if err != nil {
		fmt.Fprintln(os.Stderr, "ERROR:", err)
		os.Exit(1)
	}
}
