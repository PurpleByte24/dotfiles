-- lua/plugins/which-key.lua
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern", -- Clean UI layout matching Neovim 0.10+
      delay = 500,       -- Show menu if you pause for half a second
    },
  },
}
