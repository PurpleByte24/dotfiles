-- Setup Python host provider if the environment exists
local home_path = vim.uv.os_homedir()
local python3_path = vim.fs.joinpath(home_path, ".venv/nvim/bin/python3")
if vim.uv.fs_stat(python3_path) then
  vim.g.python3_host_prog = python3_path
end

------------------------------------------------------------------------
--                          OS & System Flags                         --
------------------------------------------------------------------------
-- Quick flags for plugins that adapt to your Mac environment
vim.g.is_win = false
vim.g.is_linux = false
vim.g.is_mac = true

vim.g.logging_level = vim.log.levels.INFO

------------------------------------------------------------------------
--                      Performance Optimizations                     --
------------------------------------------------------------------------
-- Disable legacy, slow language providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.did_install_default_menus = 1

-- Custom mapping <leader> (Spacebar!)
vim.g.mapleader = " "

-- Enable syntax highlighting for Lua code blocks embedded inside Vimscript
vim.g.vimsyn_embed = "l"

-- Force Neovim system logs/messages to English
vim.cmd([[language en_US.UTF-8]])

