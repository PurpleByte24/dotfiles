# Neovim Config — Improvement Findings

Read-only analysis pass. No files have been modified. Findings verified where possible against
upstream docs/changelogs (dates below reflect what was checked on 2026-09-11). Ordered by category;
numbering is continuous across the whole document.

Legend: **Risk** = chance this breaks something or changes behavior beyond intent.
**Keybind-adjacent** = touches a keymap, a file that defines keymaps, or a lazy-loading trigger
built from a keymap — flagged per your constraint even when the bind itself isn't changed.

---

## Bugs / Misconfigurations

### 1. `mason-lspconfig` `handlers` table is very likely a no-op — your per-server LSP settings may not be applying
- **File(s):** `lua/plugins/lsp.lua`
- **What & why:** `require("mason-lspconfig").setup({ handlers = {...} })` uses the `handlers`
  mechanism that was **removed** in `mason-lspconfig.nvim` v2.0.0 (2025-05-06), replaced by the
  native `vim.lsp.config()` / `vim.lsp.enable()` API and a new `automatic_enable` setting. Your
  `lazy-lock.json` pins `mason-lspconfig.nvim` to a commit dated **2026-05-31** — over a year past
  that removal — so this is almost certainly running a version where `handlers` is silently
  ignored. If so, your custom `pyright` (disable organize-imports, suppress style lint),
  `ruff` (E/W/F/I/N/UP/B select rules), and `rust_analyzer` (clippy + all-features) blocks are
  **not actually being applied** — those servers are likely attaching with bare defaults instead.
  Worth confirming with `:checkhealth mason-lspconfig` or `:Mason` before treating as fact, but the
  version math makes it likely.
- **Fix path:** migrate to `vim.lsp.config("pyright", {...})` / `vim.lsp.config("ruff", {...})` /
  `vim.lsp.config("rust_analyzer", {...})` + `vim.lsp.enable({...})`, or set
  `automatic_enable = false` and call `vim.lsp.enable()` yourself, per the new API.
- **Risk:** Medium-high to fix (real rewrite of this file's LSP setup logic), but leaving it as-is
  means the affected settings are already not working — arguably higher risk to leave alone.
- **Keybind-adjacent:** Yes — the `LspAttach` autocmd in this same `config()` function defines
  `gd`, `K`, and `<leader>d`. Any rewrite must carry those three mappings over unchanged.

### 2. Treesitter parser list is missing languages you're actively configuring LSPs for (at least Rust)
- **File(s):** `lua/plugins/treesitter.lua`
- **What & why:** `ts.install({ "lua", "python", "markdown", "markdown_inline", "bash" })` is the
  full parser list, but `lsp.lua` configures `rust_analyzer` with clippy — implying you edit Rust —
  and no `rust` parser is installed. Since the `FileType` autocmd calls `pcall(vim.treesitter.start)`
  for *every* filetype, any filetype without an installed parser (Rust included) silently falls back
  to legacy regex syntax highlighting with no error shown, so this is easy to miss. Worth auditing
  the list against every language you actually edit (also consider `vim` help/query files, TOML,
  YAML, JSON, etc. if used) and adding what's missing.
- **Risk:** Low — additive only, `ts.install()` is idempotent for already-installed parsers.
- **Keybind-adjacent:** No.

### 3. `vim.g.deprecation_warnings = false` is not a real Neovim option — dead config
- **File(s):** `lua/config/options.lua` (line 90)
- **What & why:** Verified against Neovim's own issue tracker: a feature request to add exactly
  this kind of global suppression flag (`neovim/neovim#28845`) was closed as "wontfix" — Neovim has
  no such setting. This line does nothing. It's likely a leftover attempt to quiet the LSP
  deprecation warning that `notify.lua` ends up hand-filtering instead (see #4).
- **Risk:** Low — removing a no-op line changes nothing observable.
- **Keybind-adjacent:** No.

### 4. `vim.notify` override silently swallows a real deprecation warning instead of fixing its source
- **File(s):** `lua/plugins/notify.lua` (lines 20-24)
- **What & why:** The override drops any message containing `"client.request is deprecated"`
  rather than surfacing it. That message means something in your setup (a plugin, or your own LSP
  code) is still calling the old `client.request(...)` form instead of the new `client:request(...)`
  method-call form. Muting it hides a real, fixable signal rather than addressing the cause — and
  will keep hiding future unrelated messages that happen to contain that substring.
- **Risk:** Low to remove the filter; identifying the actual caller may take more digging (could be
  a third-party plugin, not your own code).
- **Keybind-adjacent:** No.

### 5. Duplicate `<leader>d` diagnostic mapping (global + identical buffer-local copy)
- **File(s):** `lua/config/mappings.lua` (line 35) and `lua/plugins/lsp.lua` (line 37, inside
  `LspAttach`)
- **What & why:** Both bind `<leader>d` in normal mode to the exact same
  `vim.diagnostic.open_float`. The buffer-local copy in `LspAttach` is redundant — it just shadows
  the identical global mapping once an LSP attaches. Not broken, just dead weight.
- **Risk:** Low — removing the duplicate leaves behavior byte-for-byte identical (same key, same
  mode, same function, in every buffer either way).
- **Keybind-adjacent:** Yes — flagging explicitly per your constraint even though the resulting
  behavior is unchanged. Will not touch without your go-ahead.

---

## Deprecated / Soon-to-be-Deprecated APIs

### 6. `blink.cmp` `appearance.use_nvim_cmp_as_default = true` is flagged for removal upstream
- **File(s):** `lua/plugins/completion.lua`
- **What & why:** blink.cmp's own docs describe this option as a fallback that maps blink's
  highlight groups onto nvim-cmp's, to be removed once themes add native blink.cmp support. You're
  already on `catppuccin/nvim`, which has native blink.cmp highlight integration — so this shim is
  both unnecessary now and won't exist in a future blink.cmp release.
- **Risk:** Low — purely cosmetic (completion menu colors), no behavior/keybind change.
- **Keybind-adjacent:** No.

*(See also #1 above — `mason-lspconfig`'s `handlers`/`automatic_installation` removal is really a
deprecated-API issue, listed under Bugs since it likely already has real effects.)*

---

## Performance

### 7. `telescope.nvim` loads unconditionally at startup instead of lazy-loading
- **File(s):** `lua/plugins/telescope.lua`
- **What & why:** The plugin spec has no `cmd`/`event`/`keys` trigger, so lazy.nvim loads it (and
  `telescope-fzf-native`) on every startup regardless of whether Telescope is used that session. The
  four keymaps (`<leader>ff`, `<leader>fr`, `<leader>fs`, `<leader>fc`) are currently created inside
  the `config()` function, which only runs once the plugin loads — moving them into the plugin
  spec's `keys` table would let lazy.nvim register them as lazy-load triggers (same key, same mode,
  same command) without eagerly loading Telescope's Lua and its native fzf binary at startup.
- **Risk:** Medium — the mechanism is standard lazy.nvim practice, but it means restructuring how
  these four keymaps are declared (from `keymap.set` calls to a `keys = {...}` spec). Straightforward
  to get right, but worth care to preserve identical mode/desc/action for each.
- **Keybind-adjacent:** Yes — moves (does not remap) four existing keybind definitions.

### 8. `vim-visual-multi` loads unconditionally at startup
- **File(s):** `lua/plugins/multicursor.lua`
- **What & why:** No lazy-load trigger is set, so this VimL plugin always loads at startup. Its
  `init` function (which sets `vim.g.VM_maps`) runs at startup regardless of lazy-loading in
  lazy.nvim — only the plugin's own runtime files would be deferred — so adding
  `keys = {"<M-Down>", "<M-Up>"}` should let it lazy-load on first use of either key without
  changing when `VM_maps` is set or what the keys do.
- **Risk:** Medium — vim-visual-multi reads `g:VM_maps` on its own plugin-load lifecycle; needs
  verification in practice that lazy-triggering via `keys` doesn't change plugin-internal timing
  assumptions before trusting it blindly.
- **Keybind-adjacent:** Yes — `<M-Down>`/`<M-Up>` become the lazy-load trigger keys (unchanged
  target behavior).

### 9. Treesitter parser install runs synchronously on every startup
- **File(s):** `lua/plugins/treesitter.lua`
- **What & why:** `ts.install({...})` is called directly inside `config()`, which blocks the main
  config load path checking install status each launch. Idempotent, so no functional problem, but
  could be deferred (e.g. wrapped in `vim.schedule` or triggered from a `VimEnter`/`User VeryLazy`
  autocmd) to keep it off the synchronous startup path.
- **Risk:** Low.
- **Keybind-adjacent:** No.

### 10. `Comment.nvim` loads unconditionally (`lazy = false`) — lazy-loading possible but riskier here
- **File(s):** `lua/plugins/comment.lua`
- **What & why:** Comment.nvim defines its own default mappings (`gcc`, `gc{motion}`, `gb{motion}`,
  visual-mode `gc`/`gb`, etc.) internally rather than through user-authored keymaps, so lazy-loading
  it via a `keys` spec means manually re-declaring every one of those trigger keys/modes in the
  plugin spec. Doable, but the startup cost of this plugin is small and the chance of silently
  missing a mode variant (operator-pending vs. visual vs. normal) is real.
- **Risk:** Medium — mentioning for completeness; recommend treating as low-priority/optional given
  the poor risk/reward ratio.
- **Keybind-adjacent:** Yes — would require restating all of Comment.nvim's default binds explicitly.

---

## Plugin Redundancy / Alternatives

### 11. `vim-visual-multi` (VimL) vs. modern Lua multi-cursor plugins
- **File(s):** `lua/plugins/multicursor.lua`
- **What & why:** `mg979/vim-visual-multi` is a mature, widely-used VimL plugin, but it's not
  actively developed at the pace of Lua-native alternatives (e.g. `mini.nvim`'s multi-cursor
  addon, or `jake-stewart/multicursor.nvim` — interestingly the plugin your file's name already
  suggests). Purely informational: swapping plugins is a bigger change than anything else in this
  report since a different plugin means different mapping APIs, not just a lazy-load tweak, and per
  your constraints any such migration would need to reproduce `<M-Down>`/`<M-Up>` exactly. Not
  recommending action now — flagging for awareness only.
- **Risk:** N/A (no action proposed).
- **Keybind-adjacent:** Yes, hypothetically, if ever pursued.

---

## Structure / Organization

### 12. `lua/plugins/multicursor.lua` doesn't match the plugin it configures
- **File(s):** `lua/plugins/multicursor.lua`
- **What & why:** This file configures `mg979/vim-visual-multi`, not a plugin literally named
  "multicursor." Every other file in `lua/plugins/` is named after its plugin (`bufferline.lua`,
  `gitsigns.lua`, etc.), so this is a small discoverability trap — renaming to `visual-multi.lua`
  would match convention.
- **Risk:** Low — a pure rename (`git mv`), no config semantics change.
- **Keybind-adjacent:** No (the file's contents, including its keys, are untouched).

### 13. `lua/plugins/smart-cursor.lua` doesn't match the plugin it configures
- **File(s):** `lua/plugins/smart-cursor.lua`
- **What & why:** Configures `sphamba/smear-cursor.nvim`, but the file is named "smart-cursor."
  Same convention mismatch as #12 — rename to `smear-cursor.lua`.
- **Risk:** Low — pure rename.
- **Keybind-adjacent:** No.

### 14. Duplicate "GROUP 6" section label in mappings.lua
- **File(s):** `lua/config/mappings.lua` (lines 105 and 129)
- **What & why:** Both the "BUFFER TAB CONTROLS" and "SEARCH AND REPLACE" section headers are
  labeled `GROUP 6`. The second should read `GROUP 7`. Comment-only, but worth fixing since this
  file is clearly meant to be a readable, organized reference.
- **Risk:** Low — comment text only, zero functional/keybind change.
- **Keybind-adjacent:** No (touches only a comment line inside the keymap file).

### 15. LSP/gitsigns keymaps live outside `config/mappings.lua`, unlike everything else
- **File(s):** `lua/plugins/lsp.lua`, `lua/plugins/gitsigns.lua`, `lua/config/mappings.lua`
- **What & why:** Most keymaps are centralized in `config/mappings.lua`, but `gd`/`K`/`<leader>d`
  (LSP) and `<leader>gp` (gitsigns) are defined inside their plugin files via `LspAttach`/`on_attach`
  hooks. That's a reasonable and common pattern (these are buffer-local, attach-triggered binds that
  can't live in a static global file), but it means someone scanning only `mappings.lua` won't see
  the full keybind picture. Optional: a one-line comment in `mappings.lua` pointing to these two
  files would close that gap without moving anything.
- **Risk:** Low — purely a documentation/comment suggestion, no functional change.
- **Keybind-adjacent:** Yes (about keybind discoverability), but proposes no bind changes.

---

## Nice-to-haves / Polish

### 16. Verify the `tree-sitter` CLI is installed
- **File(s):** N/A — environment check, not a file change
- **What & why:** The new `nvim-treesitter` main-branch rewrite (which this config uses, per
  `treesitter.lua` and `lazy-lock.json`) compiles parsers locally and depends on the `tree-sitter`
  CLI being available on `$PATH`, unlike the old master branch which bundled everything. Worth
  confirming `tree-sitter --version` works (e.g. `brew install tree-sitter-cli`) so parser installs
  don't fail silently.
- **Risk:** N/A.
- **Keybind-adjacent:** No.

### 17. Vestigial `vim.uv or vim.loop` fallback in lazy.lua
- **File(s):** `lua/config/lazy.lua` (line 7)
- **What & why:** `(vim.uv or vim.loop)` is boilerplate for supporting Neovim versions older than
  0.10 (before `vim.uv` existed). Given the rest of this config already assumes Neovim 0.11+
  (native `vim.lsp.config`-adjacent tooling, new treesitter main branch), this fallback is dead
  weight — `vim.uv` alone would do. Purely cosmetic simplification.
- **Risk:** Low.
- **Keybind-adjacent:** No.

---

## Summary

- **Do first if anything:** #1 (mason-lspconfig handlers) and #2 (missing Rust parser) are the two
  items most likely to be silently affecting your actual day-to-day editing experience right now,
  not just hygiene.
- **Everything else** is safe, optional cleanup — happy to work through in whatever order/grouping
  you prefer once you've reviewed this list.

No files other than this one have been touched. Waiting for your go-ahead before making any changes.
