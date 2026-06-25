-- lua/plugins/ui.lua

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = false,
        term_colors = true,
        custom_highlights = function(colors)
          return {
            Whitespace = { fg = colors.overlay0 }, 
          }
        end,
        integrations = {
          treesitter = true,
        },
      })
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
}
