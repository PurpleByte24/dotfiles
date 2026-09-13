-- lua/plugins/treesitter-textobjects.lua
return {
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter-textobjects").setup({
        move = { set_jumps = true },
      })

      local move = require("nvim-treesitter-textobjects.move")

      -- Code-aware block jumps, replacing {/} paragraph jumps. Covers functions
      -- plus anything the language's textobjects query files under @class.outer
      -- (Rust: struct/enum/union/trait/impl/mod, Python/JS/etc: class).
      -- Bound to <leader>j/<leader>k instead of ]/[ since those need Option on a
      -- Swiss German Mac keyboard.
      local block_objects = { "@function.outer", "@class.outer" }

      vim.keymap.set({ "n", "x", "o" }, "<leader>j", function()
        move.goto_next_start(block_objects, "textobjects")
      end, { desc = "Jump to next block (function/class/struct/enum/...)" })

      vim.keymap.set({ "n", "x", "o" }, "<leader>k", function()
        move.goto_previous_start(block_objects, "textobjects")
      end, { desc = "Jump to previous block (function/class/struct/enum/...)" })
    end,
  },
}
