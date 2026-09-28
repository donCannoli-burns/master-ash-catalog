# master-ash-catalog

**Unofficial name:** **ask-wiki**

A static, provenance-first script compendium and wiki for KoLmafia `.ash` automation. The repository keeps script snapshots, their machine-readable records, and the generated static wiki together so a script is never separated from its source, hash, credit, license evidence, and warning surface.

> This is an unofficial community project. It is not an official Kingdom of Loathing or KoLmafia project.

## Layout

```text
archive/                 licensed third-party ASH snapshots, preserving source paths
records/                 one JSON provenance/index record per vendored .ash file
catalog/sources.json     source registry, credit index, official links, keyword seed
seed/                    metadata-only seeds that still need rights/provenance reconciliation
docs/                    generated static ask-wiki (GitHub Pages-ready)
cmd/askwiki/             Go CLI
internal/catalog/        sync, provenance, license, keyword, static-site code
.github/workflows/       automated sync + Pages deployment
```

## Why the archive is license-gated

The goal is to keep **actual scripts**, not just bookmarks. But public visibility is not the same as redistribution permission. `askwiki sync` clones configured repositories, detects repository-level license evidence, and only copies `.ash` bytes into `archive/` when the license is recognized. Unknown/unrecognized license states produce metadata-only blocked records instead of silently relicensing someone else's work. See [THIRD_PARTY.md](THIRD_PARTY.md).

## Every vendored script gets an HTML5 record

The static site generates a companion page for every archived `.ash` file with, when detectable:

- source repository, repository path, exact commit and SHA-256;
- author, player name, version, earliest header year and header provenance URL;
- original license evidence;
- exactly **3 key**, **6 sub**, and **12 meta** index terms;
- parsed top-level function names and imports;
- lightweight behavior signals (`read-mostly`, `mutating`, `high-impact`);
- an import-safety heuristic;
- relevant official/community reference links;
- KoL Wiki searches generated from meaningful title nouns.

The behavior scan is intentionally conservative and is **not** a safety proof.

## Run locally

Requires Go and Git.

```bash
go test ./...
go run ./cmd/askwiki sync
go run ./cmd/askwiki build
go run ./cmd/askwiki check
```

Open `docs/index.html` directly in a browser after the build.

## GitHub Actions

- `sync.yml` runs tests, refreshes licensed source snapshots, rebuilds the static wiki, checks invariants, and commits changes back to `main` when needed.
- `pages.yml` publishes `docs/` with GitHub Pages whenever `main` changes.

The sync job has a bot-loop guard so the commit it creates does not recursively run another sync.

## Keyword model

The first seed follows the KoLmafia Wiki's scripting taxonomy: character, item management, equipment, skills/effects, adventuring, in-combat consulting, math/numbers, strings, conversions, modifiers, relay/browser, properties, CLI, automation, quests, and related scripting concepts. Script-local title/function/content terms then refine the 3/6/12 index.

## Credit policy

Every GitHub owner referenced in the catalog configuration is linked from the generated Credits page. Script-level author and player attribution is preserved separately because a repository owner and a KoL player name are not always the same person.

## Adding a source

Add an entry to `catalog/sources.json`:

```json
{
  "id": "example",
  "url": "https://github.com/example/kol-script",
  "kind": "repo",
  "category": "relay / utility",
  "author": "Example",
  "player": "Example"
}
```

For a broad author bank, `kind: "github-owner"` plus `discover: true` enumerates public repositories through the GitHub API. The same license gate still applies to each discovered repository.

## Historical imports

The user-submitted seed manifest records legacy material observed during the first build, including MrEdge73 support scripts and local Don/Bale-derived utilities. Those bytes are not automatically republished until their redistribution provenance is reconciled.
