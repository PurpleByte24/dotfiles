return {
  "akinsho/toggleterm.nvim",
  keys = {
    -- open_mapping binds across normal/terminal/insert modes by default;
    -- bind explicitly to normal mode only instead.
    { "<leader>t", "<cmd>ToggleTerm<cr>", mode = "n", desc = "Toggle terminal" },
  },
  opts = {
    direction = "float",
    float_opts = {
      border = "rounded",
    },
  },
}
