-- lua/plugins/comment.lua
return {
  {
    "numToStr/Comment.nvim",
    -- Lazy-load on Comment.nvim's own default keys (no user-authored mappings here)
    keys = {
      { "gcc", mode = "n", desc = "Toggle comment line" },
      { "gbc", mode = "n", desc = "Toggle comment block" },
      { "gc", mode = { "n", "x" }, desc = "Toggle comment" },
      { "gb", mode = { "n", "x" }, desc = "Toggle block comment" },
      { "gco", mode = "n", desc = "Comment below" },
      { "gcO", mode = "n", desc = "Comment above" },
      { "gcA", mode = "n", desc = "Comment at end of line" },
    },
    opts = {}, -- Automatically configures smart context-aware commenting
  },
}
