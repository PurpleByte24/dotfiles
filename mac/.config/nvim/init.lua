-- core options
vim.opt.shortmess:append("I")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"

-- show spaces and indentation
vim.opt.list = true
vim.opt.listchars = {
  space = "·",
  trail = "·",
  extends = "›",
  precedes = "‹",
}

-- UI and behavior
vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.undofile = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.statusline = "%f"
vim.opt.mouse = "a"
vim.opt.timeoutlen = 400

-- disable lazy.nvim startup screen
vim.g.lazy_nvim_disable_startup = true

-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- plugins
require("lazy").setup({
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "neovim/nvim-lspconfig" },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },
})

-- plugin config
require("ibl").setup()

-- LSP
vim.lsp.config("lua_ls", {})
vim.lsp.enable("lua_ls")

