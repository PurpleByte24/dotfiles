-- lua/plugins/dashboard.lua

return {
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional: adds file icons if you use a Nerd Font
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- 1. Set Header Logo / Banner
      dashboard.section.header.val = {
        "                                                     ",
        "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
        "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
        "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╝██║ ",
        "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██║ ██║ ",
        "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
        "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
        "                                                     ",
      }

      -- 2. Configure Dashboard Menu Buttons
      dashboard.section.buttons.val = {
        dashboard.button("n", "  New File", "<cmd>ene <BAR> startinsert <cr>"),
        dashboard.button("f", "󰈞  Find File", "<cmd>Telescope find_files<cr>"),
        dashboard.button("r", "󰄉  Recent Files", "<cmd>Telescope oldfiles<cr>"),
        dashboard.button("s", "󰱼  Search Text", "<cmd>Telescope live_grep<cr>"),
        dashboard.button("l", "󰒲  Lazy Plugins", "<cmd>Lazy<cr>"),
        dashboard.button("c", "  Config Settings", "<cmd>e ~/.config/nvim/init.lua<cr>"),
        dashboard.button("q", "󰅚  Quit", "<cmd>qa<cr>"),
      }

      -- 3. Setup Layout
      alpha.setup(dashboard.opts)
    end,
  }
}
