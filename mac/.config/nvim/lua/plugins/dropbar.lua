-- lua/plugins/dropbar.lua
return {
  {
    "Bekaboo/dropbar.nvim",
    event = "BufReadPost",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local sources = require("dropbar.sources")
      local utils = require("dropbar.utils")
      return {
        sources = {
          path = sources.path,
        },
        bar = {
          sources = function(buf, _)
            return {
              sources.path,
              utils.source.fallback({
                sources.treesitter,
                sources.markdown,
              }),
            }
          end,
        },
      }
    end,
  },
}
