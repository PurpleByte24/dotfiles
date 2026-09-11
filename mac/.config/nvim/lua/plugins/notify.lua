-- lua/plugins/notify.lua

return {
  {
    "rcarriga/nvim-notify",
    lazy = false, -- Load immediately on startup to capture early system alerts
    config = function()
      local notify = require("notify")

      -- 1. Configure visual styles and behaviors
      notify.setup({
        background_colour = "#000000", -- Adapts to your theme transparency
        render = "compact",            -- Options: "default", "minimal", "simple", "compact"
        stages = "fade",               -- Smooth fade animation
        timeout = 3000,                -- Auto-dismiss notifications after 3 seconds
        max_width = 50,
      })

      -- 2. Modern Route: Redirect Neovim's default print mechanism to our new UI
      vim.notify = notify
    end,
  },
}