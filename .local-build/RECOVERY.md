# Interrupted Build Recovery — master-ash-catalog

## Recovery status

- task: Go static KoLmafia ASH compendium / ask-wiki, provenance index, GitHub Actions sync + Pages
- recovery_disposition: RECOVERED
- baseline_sha: `4b56fcf980feb61b87b3d596964dc7e956bd44eb`
- original_working_branch: `main`
- pre_recovery_remote_head: `68ce1a03584a2e85b55b87016fb7e14e2bc86400`
- recovery_checkpoint_sha: 61a7fb22d83ef843d2521d78fcd865037a9a847d
- recovery_state: CHECKPOINTED
- recovery_date_utc: 2026-09-28

## Recovery sources used

1. GitHub `main` branch and commit history.
2. Recursive Git tree for current `main`.
3. GitHub Actions workflow history, job steps, and logs.
4. Surviving local build artifacts under `/mnt/data/master-ash-catalog-build`.

No orphaned/unreferenced Git objects were required because the working branch had already advanced and contained the implementation.

## Inventory

Current recovered Git tree:

- 1,966 tracked blobs
- 625 `.ash` files
- 637 `.json` files
- 629 `.html` files
- 13 `.go` files
- 2 GitHub Actions workflow files

Current catalog-sync evidence from GitHub Actions run `36375662597`:

- configured sources: 57
- repositories examined: 58
- vendored scripts: 625
- license-blocked repositories: 9
- generated records: 625
- `go test ./...`: PASS
- `go run ./cmd/askwiki sync`: PASS
- `go run ./cmd/askwiki build`: PASS
- `go run ./cmd/askwiki check`: PASS
- Pages artifact upload: PASS
- Pages deployment: PASS
- deployed environment URL: `https://doncannoli-burns.github.io/master-ash-catalog/`

## Surviving local artifacts

The surviving local files are byte-identical to the corresponding current GitHub blobs:

- `README.md` — Git blob `25af2fa5c90ca51aa572c492b3ab82f6b44fbc54`
- `CONTRIBUTING.md` — Git blob `312548765ff7d59d861f7ae502a974492247a743`
- `THIRD_PARTY.md` — Git blob `c87d06ecd2ec826d9843539863e306c6787cde81`

## Missing / conflicts

- known missing implementation files: none
- known content conflicts: none
- intentionally non-vendored material: repositories/scripts blocked by the catalog's license/provenance gate
- local checkout verification: not rerun in the recovery container because outbound DNS to GitHub was unavailable; the successful GitHub Actions run is the authoritative verification evidence

## Known non-blocking CI warnings

- setup-go could not restore a module cache because the repository currently has no `go.sum`.
- GitHub-hosted runner emitted Node.js action-runtime deprecation warnings.
- Neither warning failed the build, catalog invariant check, artifact upload, or Pages deployment.

## Post-recovery acceptance audit

- source repair commit: `853bce2efff333319298333ca96477e0ce2e16e8`
- regenerated catalog head: `f28b7185df58b1fa7f0afc42fcad4b08327a3034`
- repair workflow run: `36380183788`
- unit tests: PASS
- source sync: PASS
- static build: PASS
- invariant check: PASS
- Pages deployment: PASS
- representative HTML readback: PASS
- representative 3/6/12 keyword readback: PASS

The acceptance audit found and repaired two narrow defects: script pages did not expose already-known player/provenance metadata explicitly, and generic function words could leak into keyword sets. The regenerated pages now expose known author/player/year/version/provenance fields, and the keyword ranker filters generic tokens before cardinality fill.

## Last completed capability

A scheduled/manual/push-triggered Go catalog pipeline can discover configured sources, license-gate vendoring, generate per-script provenance JSON + HTML, validate archive/record/page invariants, commit refreshed catalog data, and deploy the resulting static wiki to GitHub Pages.

## Next smallest action

Review blocked source licenses/provenance one repository at a time if broader byte-level archival coverage is desired. Do not bypass the redistribution gate merely to increase script count.
