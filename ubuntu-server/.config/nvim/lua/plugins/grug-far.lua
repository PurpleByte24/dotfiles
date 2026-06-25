-- lua/plugins/grug-far.lua
return {
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = {
      {
        "<leader>gf",
        function()
          require("grug-far").open({ transient = true })
        end,
        desc = "Search and replace (project-wide)",
      },
      {
        "<leader>sw",
        function()
          require("grug-far").open({
            transient = true,
            prefills = { search = vim.fn.expand("<cword>") },
          })
        end,
        desc = "Search and replace word under cursor",
      },
    },
    opts = {},
  },
}
