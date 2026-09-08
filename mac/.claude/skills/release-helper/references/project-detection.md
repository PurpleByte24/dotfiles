# Project detection edge cases

## Cargo workspaces

Check whether the workspace uses a shared version:

```toml
[workspace.package]
version = "0.2.2"
```

...with member crates inheriting it via `version.workspace = true` in their
own `Cargo.toml`, versus each crate having an independent `version =` line.
If independent, ask the user which crate(s) this release covers — a single
git tag may not map cleanly to "the whole workspace bumped together."

## Monorepos / multiple release units

If there are multiple independently-versioned packages in one repo (e.g. a
`packages/` directory with several `package.json` files, or a Cargo
workspace with genuinely independent crate versions and separate CI release
triggers per crate), don't assume "the project's version" is singular.
Ask which package(s) are being released, and whether they share a tag
namespace (e.g. `pkg-a-v1.2.0` vs a flat `v1.2.0`).

## No CI release workflow found

Say so plainly: "I didn't find a tag-triggered release workflow in
`.github/workflows/` or `.gitea/workflows/` — after tagging, you'll need to
[cut the release / trigger the build] manually, or let me know if it lives
somewhere else." Don't assume manual release steps that may not apply.

## CI does not derive version from tag

If the release workflow does NOT strip the version from `GITHUB_REF_NAME`
(or equivalent) and instead expects the manifest to already contain the
target version at tag time, the order of operations flips: the manifest
edit + commit must happen _before_ tagging, not derived from the tag
afterward. Detect this by checking whether the workflow does something like:

```yaml
run: |
  version="${GITHUB_REF_NAME#v}"
  sed -i ... Cargo.toml
```

If absent, and the workflow instead just reads `Cargo.toml`/`package.json`
as-is (e.g. via `cargo publish`, `npm publish`, `poetry build`), the manifest
must be correct _before_ the tag is pushed. Tell the user this explicitly
and offer to make that edit first — always naming the exact file and field
per their stated preference for file-change suggestions.

## Go modules

`go.mod` has no version field — Go module versions are purely git tags
(`vX.Y.Z`). There's no manifest to check/bump; the whole "detect version
field" step is moot. Skip straight to the commit-history analysis and tag
step. Note: Go's module system treats `v2+` tags specially (requires a
`/v2` suffix in the module path) — flag this if a MAJOR bump crosses from
`v1.x` to `v2.0.0` or higher, since it has extra implications beyond just
the tag.
