-- lua/plugins/multicursor.lua
return {
  {
    "mg979/vim-visual-multi",
    branch = "master",
    init = function()
      vim.g.VM_maps = {
        ["Add Cursor Down"] = "<M-Down>",  -- Option+Down
        ["Add Cursor Up"]   = "<M-Up>",    -- Option+Up
      }
    end,
  },
}
