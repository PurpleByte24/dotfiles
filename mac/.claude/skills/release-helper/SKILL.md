---
name: release-helper
description: Prepares a new version release for a project — detects the language/package manifest and CI release trigger, reviews commits since the last tag to propose a SemVer bump with reasoning, drafts or checks CHANGELOG.md, and (only after explicit user confirmation of the version) creates and pushes the git tag. Use this whenever the user wants to "cut a release", "make a new version", "tag a release", asks "what version bump is this", or wants help figuring out if a change is major/minor/patch. Also trigger if the user mentions CHANGELOG.md being out of date around release time. Do NOT auto-tag or auto-push without an explicit confirmation message from the user naming the version.
---

# Release Helper

Prepares a repo for a new version tag: detects the project's versioning setup,
proposes a SemVer bump backed by evidence from commit history, keeps
`CHANGELOG.md` honest, and — only once the user has explicitly confirmed a
version number — creates and pushes the tag.

**This skill proposes; it does not decide.** The bump suggestion is a
starting point for the user's judgment, not a verdict to act on
automatically. Tagging and pushing require an explicit, unambiguous
confirmation message from the user that names the version (e.g. "yes, 0.3.0"
or "tag it as 1.0.0"). A vague "looks good" is not sufficient — ask the user
to state the version they want if their confirmation doesn't include it.

## Workflow

### Step 1 — Detect the project

Identify the manifest and where the version lives:

| Manifest found              | Version field                                        |
| --------------------------- | ---------------------------------------------------- |
| `Cargo.toml` (workspace)    | `[workspace.package] version`                        |
| `Cargo.toml` (single crate) | `[package] version`                                  |
| `package.json`              | `"version"`                                          |
| `pyproject.toml`            | `[project] version` or `[tool.poetry] version`       |
| `go.mod`                    | no in-repo version field; versions are git tags only |

If none of these are found, ask the user where the version lives rather than
guessing.

Also check for a CI release workflow (commonly `.github/workflows/*.yml`,
`.gitea/workflows/*.yml`, or similar). Look for what triggers it:

- **Tag-push triggered** (`on.push.tags`, e.g. `v*.*.*`) — the common case,
  matches the pattern in this user's `hyperwm` project. Version is typically
  derived from the tag in CI, not hand-edited pre-tag.
- **Branch-push / manual triggered** — version is likely still committed by
  hand pre-tag; note this difference to the user, since the tag-then-push
  order matters differently here.
- **No CI release workflow found** — say so, don't assume one exists.

Read `references/project-detection.md` for edge cases (workspaces with
per-crate versions, monorepos with multiple release units, etc.) if the
straightforward cases above don't fit.

### Step 2 — Gather evidence since the last tag

```bash
git fetch --tags
last_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "<none>")
git log "${last_tag}..HEAD" --oneline
```

If there is no previous tag, say so and treat this as the first release
(skip bump reasoning — ask the user what the starting version should be).

Collect the full commit messages (not just `--oneline`) since they carry the
signal:

```bash
git log "${last_tag}..HEAD" --format='%H%n%s%n%b%n---'
```

### Step 3 — Propose a bump, with reasoning shown

Classify commits using Conventional Commits prefixes if present
(`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `BREAKING CHANGE:` footer
or `!` after the type, e.g. `feat!:`). See
`references/conventional-commits.md` for the full mapping.

Bump logic:

- Any `BREAKING CHANGE:` footer or `type!:` → **MAJOR** (or, if current
  version is `0.x.y`, flag it as "would be MAJOR post-1.0, currently 0.x so
  convention allows MINOR — your call")
- Any `feat:` commit, no breaking change → **MINOR**
- Only `fix:`/`perf:`/similar → **PATCH**
- Only `chore:`/`docs:`/`ci:`/`test:`/`style:` → likely no user-facing bump
  needed at all; say so explicitly rather than forcing a suggestion

**If commits don't follow Conventional Commits**, don't force-fit them.
Instead, summarize what changed in plain language grouped by file/area
touched, and say the bump is a judgment call — offer your best guess but
flag the lower confidence clearly. Never silently guess-and-proceed as if
you were certain.

Present the proposal like this, then stop and wait for the user:

```
Since v0.2.2 (14 commits):
  - 3 feat:  (colored status output, new `--json` flag, config validation)
  - 5 fix:   (panic on missing config, race in daemon reconnect, ...)
  - 6 chore/docs/ci

No breaking changes detected.
→ Suggests MINOR: 0.2.2 → 0.3.0

Does that look right, or would you like a different version?
```

If confidence is low (no conventional commits, ambiguous changes, or a
change that's arguably breaking but not marked as such), say so plainly in
the proposal instead of hiding the uncertainty.

### Step 4 — CHANGELOG.md

Look for `CHANGELOG.md` (or `CHANGELOG.md` in a `docs/` dir). If found:

1. Check whether commits since the last tag are reflected in an "Unreleased"
   section or missing entirely.
2. If missing, draft entries **from the commit messages** (per the user's
   preference — not from diff content), grouped under `## [Unreleased]` or a
   new `## [<proposed-version>] - <date>` heading, following the Keep a
   Changelog style if the existing file already uses it:

```markdown
## [0.3.0] - 2026-09-08

### Added

- Colored output and improved error messages for `status` subcommand

### Fixed

- Panic on missing config file
- Daemon reconnect race condition
```

3. Show the user the drafted section as a diff/preview. Ask them to confirm
   or edit before writing it to the file. Don't write silently.

If `CHANGELOG.md` doesn't exist, ask whether the user wants one created —
don't assume.

### Step 5 — Confirm version, then tag and push

Only proceed here once the user has sent an explicit message confirming a
specific version number (see the note at the top of this file). If their
reply is ambiguous ("sure", "go ahead") without a version number, ask them
to state it plainly before doing anything irreversible.

Once confirmed:

```bash
version="<confirmed-version>"   # no leading v yet
tag="v${version}"

if git rev-parse "$tag" >/dev/null 2>&1; then
  echo "tag $tag already exists" >&2
  exit 1
fi

git tag "$tag"
git push origin "$tag"
```

If CHANGELOG.md edits were confirmed in Step 4 but not yet committed, commit
those _before_ tagging (so the tag includes the changelog entry):

```bash
git add CHANGELOG.md
git commit -m "docs: update changelog for ${tag}"
git push origin HEAD
git tag "$tag"
git push origin "$tag"
```

Do not touch the manifest's version field by hand if CI derives it from the
tag (Step 1 detection). If CI does _not_ derive it from the tag, tell the
user the manifest edit + commit needs to happen before tagging, and offer to
do that edit for them — noting exactly which file and field, per their
stated preference for always naming the file for changes.

## What this skill never does automatically

- Never tags or pushes without an explicit, version-naming confirmation
  message from the user in this conversation.
- Never force-classifies a bump with high confidence when commits don't
  support that confidence — surfaces uncertainty instead.
- Never silently rewrites CHANGELOG.md — always previews first.
- Never assumes a CI release mechanism exists or works a particular way —
  checks the actual workflow file(s) in the repo.
