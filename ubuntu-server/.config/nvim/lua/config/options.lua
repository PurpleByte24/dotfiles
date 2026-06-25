-- lua/config/options.lua
local opt = vim.opt

-- ==========================================
-- WINDOW SPLITS & INTERFACE FILLCHARS
-- ==========================================
opt.fillchars = {
  fold = " ",
  foldsep = " ",
  foldopen = "",
  foldclose = "",
  vert = "│",
  eob = " ",
  msgsep = "‾",
  diff = "╱",
}

opt.list = true
opt.listchars = {
  tab = "→ ",
  trail = "·",
  lead = "·",
  nbsp = "␣",
}

opt.splitbelow = true  -- Horizontal splits open below
opt.splitright = true  -- Vertical splits open to the right
opt.splitkeep = "screen" -- Prevent screen flickering when splitting

opt.timeoutlen = 500   -- Time to wait for a mapped sequence (ms)
opt.updatetime = 500   -- Faster trigger for internal UI events

-- ==========================================
-- SYSTEM INTEGRATION (CLIPBOARD & FILE)
-- ==========================================
-- Sync Neovim buffer yanks seamlessly with macOS clipboard (⌘V)
opt.clipboard:append("unnamedplus")

opt.swapfile = false   -- Disable old-school swap files
opt.backup = false     -- Disable duplicate file backups
opt.writebackup = false 
opt.undofile = true    -- Persistent undo history across editor sessions

-- Global file types/directories to ignore during auto-completion searching
opt.wildignore:append {
  "*.o", "*.obj", "*.dylib", "*.bin", "*.dll", "*.exe",
  "*/.git/*", "*/.svn/*", "*/__pycache__/*", "*/build/**",
  "*.jpg", "*.png", "*.jpeg", "*.bmp", "*.gif", "*.DS_Store"
}
opt.wildignorecase = true -- Ignore case when filtering file searches

-- ==========================================
-- DEFAULT INDENTATION & TABS (Default to 2)
-- ==========================================
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true   -- Convert physical tabs to spaces
opt.shiftround = true  -- Round indent spaces to match shiftwidth

-- ==========================================
-- CODING LUXURIES & VISUALS
-- ==========================================
opt.number = true          -- Show line number
opt.relativenumber = true  -- Show relative distance numbers

opt.ignorecase = true      -- Case-insensitive searching...
opt.smartcase = true       -- ...until an uppercase letter is explicitly typed

opt.linebreak = true       -- Don't break wrap text mid-word
opt.showbreak = "↪ "       -- Character to show on wrapped lines
opt.wrap = false           -- Default to flat code rows (no wrapping)

opt.scrolloff = 8          -- Pad top/bottom with 8 lines before screen scrolls
opt.mouse = "n"            -- Enable mouse clicks inside Normal mode buffers
opt.showmode = false       -- Statusline plugin handles mode displays, hide default

-- Complete options for popup auto-suggestions
opt.completeopt = { "menuone", "noselect" }
opt.pumheight = 10         -- Limit dropdown menu to 10 rows max
opt.pumblend = 5           -- Slight transparency for the completion menu

opt.signcolumn = "yes:1"   -- Keep the git status/error column open permanently
opt.colorcolumn = "100"    -- Vertical guide line at column 100

-- Ensure rich 24-bit RGB terminal theme rendering
opt.termguicolors = true

-- Suppress background API deprecation warning logs from older external plugins
vim.g.deprecation_warnings = false

-- ==========================================
-- PERFORMANCE GREP CONFIG (RipGrep support)
-- ==========================================
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --no-heading --smart-case"
  opt.grepformat = "%f:%l:%c:%m"
end

-- ==========================================
-- LANGUAGE-SPECIFIC OVERRIDES
-- ==========================================
-- Set up custom indentation rules for Python files (4 spaces)
vim.api.nvim_create_augroup("CustomIndent", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "CustomIndent",
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})
