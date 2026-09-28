# Source registry

`catalog/sources.json` is the ingest authority for **ask-wiki**.

- `repo` entries are cloned directly.
- `github-owner` entries discover public repositories for an author/organization and then apply the same license gate.
- `reference` entries are credit/research links and are not treated as ASH source repositories.
- A source may be indexed without being redistributed. Script bytes enter `archive/` only when repository-level redistribution evidence is recognized by the synchronizer or a future manual provenance record explicitly authorizes them.

The generated wiki never treats an archive listing as an endorsement or a guarantee that a script is current, safe, or compatible with a present KoLmafia runtime.
