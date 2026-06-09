-- lua/config/lazy.lua

-- 1. Setup the path where lazy.nvim will be installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- 2. If the folder doesn't exist, clone it from GitHub
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

-- 3. IMPORTANT: Add the lazypath to Neovim's runtime path 
-- Without this line, require("lazy") will fail with E5113
vim.opt.rtp:prepend(lazypath)

-- 4. Now it is safe to require "lazy"
require("lazy").setup({
  spec = {
    -- This will pull from your lua/plugins/ folder
    { import = "plugins" },
  },
  ui = {
    border = "rounded",
  },
})
