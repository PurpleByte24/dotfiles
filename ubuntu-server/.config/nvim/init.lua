-- init.lua

-- 1. Load globals, system flags, and leader key
require("config.globals")

-- 2. Load basic editor preferences and indentation behavior
require("config.options")

-- 3. Load your custom keymaps
require("config.mappings")

-- 4. Initialize the lazy.nvim plugin manager
require("config.lazy")
