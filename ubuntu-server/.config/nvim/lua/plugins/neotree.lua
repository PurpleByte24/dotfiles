-- lua/plugins/neotree.lua

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      {
        "<leader>e",
        function()
          -- Check if a Neo-tree buffer currently exists in any active window
          local neotree_win = nil
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "neo-tree" then
              neotree_win = win
              break
            end
          end

          -- Execute your custom smart routing rules
          if neotree_win then
            if vim.api.nvim_get_current_win() == neotree_win then
              -- If open AND focused: close it entirely
              vim.cmd("Neotree close")
            else
              -- If open but NOT focused: jump focus right into it
              vim.cmd("Neotree focus")
            end
          else
            -- FORCE focus immediately upon a fresh opening
            vim.cmd("Neotree focus left")
          end
        end,
        desc = "Smart Neo-tree Toggle/Focus",
      },
      {
        "<leader>bf",
        "<cmd>Neotree filesystem reveal left<cr>",
        desc = "Reveal current file in explorer",
      },
    },
    config = function()
      require("neo-tree").setup({
        window = {
          width = 30,
          mappings = {
            ["space"] = "none", -- Disable space trigger inside the tree so it doesn't conflict with your leader key
            ["l"] = "open", -- open file/expand folder
            ["h"] = "close_node", -- collapse folder with
            ["H"] = "close_all_nodes", -- collapse everything
            ["L"] = "expand_all_nodes", -- expand recursively
          },
        },
        filesystem = {
          filtered_items = {
            visible = true, -- Show hidden files cleanly
            hide_dotfiles = false, -- Don't hide dotfiles like .config
            hide_gitignored = false,
          },
          follow_current_file = {
            enabled = true, -- Automatically focus the active file in the tree
          },
        },
      })
    end,
  },
}
