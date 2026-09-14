# nvim input lag investigation (2026-09-14)

## Symptom
Typing lag up to ~1s, only after nvim had been open a while — not at fresh
start. `:profile` during a laggy session showed nothing expensive in
Lua/Vimscript.

## Method
Ruled out: startup cost, LSP symbol source (dropbar), swap growth as the
direct trigger. Set up a background sampler (ps state/RSS for
nvim/rust-analyzer/cargo/clippy/rustc + `sysctl vm.swapusage` + `vm_stat`,
polled every 0.5s) and correlated timestamps with live reproductions.

## Root cause — two separate mechanisms, both confirmed live

**1. checkOnSave forking a full external build (fires only on save).**
`lua/plugins/lsp.lua` had `rust_analyzer` checkOnSave set to
`check.extraArgs = { "--all", ... }` (whole-workspace clippy, not just the
current package) plus `cargo.allFeatures = true` (every feature combination
compiled). Live capture caught the exact process tree spawned on save:
`cargo-clippy → cargo → clippy-driver ×2`, running as real child processes of
rust-analyzer — genuine external CPU/memory contention from a live cargo
build. This explains save-triggered freezes but NOT lag during plain typing
with no save.

**2. rust-analyzer's own per-keystroke analysis saturating all CPU cores
(fires on typing, no save needed).** After fixing #1, lag still reproduced
while just typing. A second live capture caught it directly: no cargo/clippy
process anywhere nearby, but `rust-analyzer` itself spiked to 42.5% CPU with
a +32MB RSS jump in under a second, `nvim` simultaneously spiking to 32.6%
CPU — in-process incremental re-analysis after a single edit, not a build.
This machine is an 8-core M1 (4 performance + 4 efficiency) already sitting
near its memory ceiling at idle (`top -l 1`: ~460MB free, 2.6GB in the
compressor, out of 8GB total). rust-analyzer's default thread pool is one
worker per logical CPU (8), so a single keystroke's re-analysis burst can
grab most/all cores at once, starving nvim's main thread of scheduling time
for up to ~1s and forcing the memory compressor to work harder (itself CPU
cost) — all outside nvim's process, hence invisible to `:profile`.

Both mechanisms are corroborated by live `ps`-based process monitoring
(RSS/CPU/state sampled every 0.5s), not guesswork. Swap stayed flat at 767MB
throughout every capture, ruling out swapping/memory-leak theories entirely —
this was always CPU/scheduler contention, not paging.

## Fix
- Dropped `--all` and `cargo.allFeatures` from `rust_analyzer` settings —
  checkOnSave now scopes to the current package with default features, still
  using clippy as the linter.
- Added `rust-analyzer.numThreads = 3` to cap rust-analyzer's own worker pool,
  leaving headroom on the 4 performance cores for nvim/UI/OS instead of
  letting a single edit's analysis burst claim all 8 logical CPUs.

## Verify
Save a file repeatedly in a Rust buffer; confirm no multi-crate
`clippy-driver` tree spawns. Separately, just type/edit for a while with no
saves; confirm rust-analyzer's CPU no longer spikes past ~3 cores' worth
(~37% on this 8-core machine) per edit. If lag still recurs, next things to
check: whether `numThreads` needs to go lower still, or whether closing other
memory-heavy apps to free real RAM (not just compressor headroom) helps —
the machine's baseline memory pressure (2.6GB compressed at idle) is the
underlying constraint here, not something nvim config alone can fully solve.
