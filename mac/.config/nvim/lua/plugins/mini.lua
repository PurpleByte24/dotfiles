-- lua/plugins/mini.lua
return {
  {
    "echasnovski/mini.nvim",
    version = false,
    event = "VeryLazy",
    config = function()
      -- Highlight all occurrences of the word under the cursor
      require("mini.cursorword").setup()

      -- Move lines/selections with Alt+hjkl (replaces the hand-rolled
      -- <A-j>/<A-k> mappings that used to live in config/mappings.lua)
      require("mini.move").setup()

      -- Smooth animations for cursor movement, scrolling, resizing, open/close.
      -- Cursor animation disabled since smear-cursor.nvim already owns that.
      require("mini.animate").setup({
        cursor = { enable = false },
      })
    end,
  },
}
