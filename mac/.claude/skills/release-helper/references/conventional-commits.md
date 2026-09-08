# Conventional Commits → SemVer mapping

Format: `<type>[optional scope][!]: <description>`

Optional body/footer may contain `BREAKING CHANGE: <description>`.

## Type → bump mapping

| Prefix                        | Meaning                     | Bump                                             |
| ----------------------------- | --------------------------- | ------------------------------------------------ |
| `feat:`                       | new feature                 | MINOR                                            |
| `fix:`                        | bug fix                     | PATCH                                            |
| `perf:`                       | performance improvement     | PATCH                                            |
| `refactor:`                   | code change, no feature/fix | none (unless paired with feat/fix in same range) |
| `docs:`                       | documentation only          | none                                             |
| `style:`                      | formatting, whitespace      | none                                             |
| `test:`                       | adding/fixing tests         | none                                             |
| `chore:`                      | tooling, deps, misc         | none                                             |
| `ci:`                         | CI config changes           | none                                             |
| `build:`                      | build system changes        | none                                             |
| `revert:`                     | reverts a previous commit   | depends on what's reverted                       |
| `type!:` (any type + `!`)     | breaking change             | MAJOR                                            |
| footer `BREAKING CHANGE: ...` | breaking change             | MAJOR                                            |

## Determining the overall bump for a range

Take the **highest** bump implied by any commit in the range:
`MAJOR > MINOR > PATCH > none`.

One `feat:` among ten `fix:` commits still means MINOR overall, not PATCH.

## Pre-1.0 (0.x.y) nuance

SemVer's spec technically allows any change in `0.x` to be breaking — the
MAJOR/MINOR/PATCH compatibility guarantee only formally applies from `1.0.0`
onward. In practice, most projects still track the same signal
(breaking → bump the middle digit, i.e. what would be MINOR pre-1.0 for a
breaking change, since MAJOR is reserved for "we've hit 1.0"). When a
breaking change is detected pre-1.0, flag both readings to the user and let
them decide — don't silently pick one.

## When commits don't follow this convention

Don't force a classification. Instead:

- Group the commit list by area/file touched (e.g. "3 commits touching
  `crates/hyperwm-cli/src/status.rs`", "2 commits touching CI config")
- Describe in plain language what user-facing behavior likely changed
- State explicitly that the bump suggestion is lower-confidence and invite
  the user to correct it

Never claim high confidence in a bump derived from unstructured commit
messages — the accuracy just isn't there without the type prefixes.
