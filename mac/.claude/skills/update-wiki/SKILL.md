---
name: update-wiki
description: Regenerates wiki/*.md pages in a source repo by diffing current code against the source_commit recorded in each page's frontmatter. Only touches pages whose scoped source_paths actually changed. Run from the root of a source repo (k8s-infra, kvm-infra, prebaked-gitea-runner, cicd-common, gitea-backup-tools).
---

# update-wiki

## Purpose

Keep `wiki/*.md` in a source repo current without a full rewrite on every
invocation. Each page records the commit it was last generated against and
the code paths it documents; this skill regenerates only pages whose scoped
paths changed since that commit.

## When to run

Manually, via `claude update-wiki`, from the root of one of the source repos.
Not run from the `wiki` aggregator repo — that repo only consumes `wiki/`
folders at build time via sparse checkout, it never generates content.

## Frontmatter schema

```yaml
---
title: "Human-readable page title"
category: "Category used for mkdocs nav grouping"
order: 10                      # sort order within category
source_commit: "a1b2c3d"       # 7-char SHA this page was last generated from
source_paths:                  # glob(s) this page documents — scopes the diff
  - "infra/networking/tailscale/**"
  - "docs/tailscale-dns.md"
updated: 2026-08-02
---
```

`source_paths` is required on every page. If a page predates this field,
treat it as stale and prompt for `source_paths` before regenerating it —
don't guess scope silently.

## Procedure

1. Run `git rev-parse --short=7 HEAD` to get the current commit SHA.
2. Enumerate all `wiki/*.md` files. For each, parse frontmatter.
3. For each page, run `git diff --name-only <source_commit>..HEAD -- <source_paths>`.
   - Empty result → page is current, skip it. Do not touch the file.
   - Non-empty result → page is stale, regenerate it (step 4).
4. To regenerate a stale page:
   - Read the current content of the files matching `source_paths`.
   - Rewrite the page body to reflect current state. Preserve `title`,
     `category`, and `order` unless the change clearly warrants updating
     them (e.g. the documented component was renamed).
   - Set `source_commit` to the current HEAD SHA and `updated` to today's date.
5. After processing all existing pages, check for source paths with no
   corresponding wiki page at all (e.g. a new app added under `infra/` or a
   new top-level component). Propose a new page for each, with a suggested
   `category`, `order` (append at end of its category), and `source_paths`
   scoped to what was found. Do not create the page without confirmation —
   list proposals and wait.
6. Print a summary: pages regenerated, pages skipped (current), pages
   proposed as new. No other output.

## Guardrails

- Never invoke `sops -d` or any decryption command. Treat `*.enc.yaml` files
  as opaque — their existence and filename are enough context; their
  contents are never read or summarized.
- If a file that should be encrypted (matches `.sops.yaml`'s
  `encrypted_regex` scope, e.g. a `data:`/`stringData:` block in a
  `02-secret*.yaml`) appears to contain plaintext, stop and flag it instead
  of proceeding. Do not summarize the plaintext value.
- Never modify anything outside `wiki/*.md`. No source code, no manifests,
  no `kustomization.yaml`.
- Never fabricate a `source_commit` or `updated` date — always derive them
  from actual `git` output.
- If `git diff` scope (`source_paths`) can't be resolved (e.g. glob matches
  nothing, path was deleted), flag the page as needing manual attention
  rather than silently leaving it unchanged or guessing new scope.
