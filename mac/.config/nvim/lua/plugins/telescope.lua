-- lua/plugins/telescope.lua

return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Native sorter to make searches mathematically faster on your Mac
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-tree/nvim-web-devicons",
    },
    -- also lazy-load on the :Telescope command so the alpha dashboard buttons
    -- (which call it directly, not via the keys below) still work
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Fuzzy find files in project" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Fuzzy find recent files" },
      { "<leader>fs", "<cmd>Telescope live_grep<cr>", desc = "Find string in project (RipGrep)" },
      { "<leader>fc", "<cmd>Telescope grep_string<cr>", desc = "Find string under cursor" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          path_display = { "smart" },
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous, -- Move to premium result
              ["<C-j>"] = actions.move_selection_next,     -- Move to next result
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            },
          },
        },
      })

      -- Load the ultra-fast FZF native extension
      telescope.load_extension("fzf")
    end,
  },
}