-- lua/plugins/treesitter.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")

      ts.setup({
        install_dir = vim.fn.stdpath("data") .. "/site"
      })

      -- Defer the install check off the synchronous startup path
      vim.schedule(function()
        ts.install({ "lua", "python", "rust", "markdown", "markdown_inline", "bash" })
      end)

      -- Auto-activate treesitter highlighting on every buffer
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
}