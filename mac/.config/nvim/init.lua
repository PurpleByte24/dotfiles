-- treesitter: parsers to install
vim.g.ts_ensure_installed = { "lua", "bash", "yaml", "json", "python", "go" }

-- core options
vim.opt.shortmess:append("I")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"

-- show spaces and indentation
vim.opt.list = true
vim.opt.listchars = {
  space = "·",
  trail = "·",
  tab = "→ ",
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

-- filetype overrides (ftplugins can override global settings)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sh", "bash", "zsh", "yaml", "json", "lua", "python" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Makefiles must use real tabs
vim.api.nvim_create_autocmd("FileType", {
  pattern = "make",
  callback = function()
    vim.opt_local.expandtab = false
  end,
})

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
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      vim.treesitter.language.register("bash", "sh")
    end,
  },
  { "neovim/nvim-lspconfig" },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl" },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
  },
  -- auto pairs
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },

  -- git
  { "lewis6991/gitsigns.nvim" },
  { "tpope/vim-fugitive" },

  -- start screen
  { "goolord/alpha-nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
})

-- indent-blankline
require("ibl").setup()

-- gitsigns
require("gitsigns").setup()

-- dashboard
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
  "                                                     ",
  "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
  "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
  "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
  "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
  "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
  "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
  "                                                     ",
}

dashboard.section.buttons.val = {
  dashboard.button("f", "  Find file",    "<cmd>Telescope find_files<CR>"),
  dashboard.button("r", "  Recent files", "<cmd>Telescope oldfiles<CR>"),
  dashboard.button("g", "  Live grep",    "<cmd>Telescope live_grep<CR>"),
  dashboard.button("q", "  Quit",         "<cmd>qa<CR>"),
}

alpha.setup(dashboard.opts)

-- nvim-cmp
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"]      = cmp.mapping.confirm({ select = true }),
    ["<Tab>"]     = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
      else fallback() end
    end, { "i", "s" }),
    ["<S-Tab>"]   = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then luasnip.jump(-1)
      else fallback() end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
  }),
})

-- shared LSP capabilities (tells servers what nvim-cmp supports)
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- LSP servers
-- requires: brew install lua-language-server
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  cmd = { "lua-language-server" },
})
vim.lsp.enable("lua_ls")

-- requires: brew install bash-language-server shellcheck shfmt
vim.lsp.config("bashls", { capabilities = capabilities })
vim.lsp.enable("bashls")

-- requires: brew install yaml-language-server
vim.lsp.config("yamlls", {
  capabilities = capabilities,
  settings = {
    yaml = {
      schemas = {
        ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.0-standalone-strict/all.json"] = "/*.yaml",
      },
      validate = true,
    },
  },
})
vim.lsp.enable("yamlls")

-- LSP keymaps (only active when LSP attaches to a buffer)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd",         vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K",          vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr",         vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>f",  vim.lsp.buf.format, opts)
    vim.keymap.set("n", "[d",         vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d",         vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<leader>e",  vim.diagnostic.open_float, opts)
  end,
})

-- Telescope keymaps
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", telescope.find_files)
vim.keymap.set("n", "<leader>fg", telescope.live_grep)
vim.keymap.set("n", "<leader>fb", telescope.buffers)
vim.keymap.set("n", "<leader>fh", telescope.help_tags)
