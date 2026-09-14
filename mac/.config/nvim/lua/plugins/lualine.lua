-- lua/plugins/lualine.lua
return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false, -- Load immediately on startup alongside your theme
    config = function()
      require("lualine").setup({
        options = {
          -- "auto" will dynamically read "catppuccin-mocha" from your active
          -- colorscheme, perfectly applying the theme without timing errors!
          theme = "auto",
          component_separators = { left = "│", right = "│" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "filetype" },
          lualine_y = {},
          lualine_z = {},
        },
      })
    end,
  },
}