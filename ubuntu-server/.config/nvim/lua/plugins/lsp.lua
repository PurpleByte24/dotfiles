-- lua/plugins/lsp.lua
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- 1. Initialize Mason (the package installer)
      require("mason").setup()

      -- 2. Configure diagnostic display
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          spacing = 4,
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        float = {
          border = "rounded",
          source = true,
        },
      })

      -- 3. Configure standard shortcuts when an LSP connects to a file buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
          end
          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("K", vim.lsp.buf.hover, "Hover documentation")
          map("<leader>d", vim.diagnostic.open_float, "Show diagnostic")
        end,
      })

      -- 4. Use mason-lspconfig to bridge into Neovim's updated native config manager
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "ruff" },
        handlers = {
          function(server_name)
            local server = vim.lsp.config[server_name] or {}
            server.setup = server.setup or {}
            require("lspconfig")[server_name].setup(server.setup)
          end,

          -- Pyright: type checking only, let ruff own linting
          ["pyright"] = function()
            require("lspconfig").pyright.setup({
              settings = {
                pyright = {
                  disableOrganizeImports = true, -- ruff handles this
                },
                python = {
                  analysis = {
                    ignore = { "*" }, -- suppress pyright style/lint noise
                    typeCheckingMode = "basic",
                  },
                },
              },
            })
          end,

          -- Ruff: linting + formatting diagnostics
          ["ruff"] = function()
            require("lspconfig").ruff.setup({
              init_options = {
                settings = {
                  lint = {
                    select = { "E", "W", "F", "I", "N", "UP", "B" },
                    -- E/W = pycodestyle (PEP-8), F = pyflakes, I = isort,
                    -- N = naming, UP = pyupgrade, B = bugbear
                  },
                },
              },
            })
          end,
        },
      })
    end,
  },
}
