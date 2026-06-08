-- lua/plugins/completion.lua
return {
  {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = "rafamadriz/friendly-snippets",
    version = "1.*",
    
    opts = {
      keymap = {
        preset = "none",
        
        -- Re-bind the vital commands back to clean, predictable keys
        ["<C-space>"] = { "show", "show_documentation", "hide" },
        ["<CR>"] = { "accept", "fallback" }, -- Enter accepts autocomplete words cleanly
        
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      },
      
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono"
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },
}