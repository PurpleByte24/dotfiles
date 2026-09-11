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
        end,
      })

      -- 4. Per-server settings via the native vim.lsp.config() API
      -- (mason-lspconfig v2+ removed the old `handlers` bridge; it now auto-enables
      -- installed servers via vim.lsp.enable(), picking up whatever is registered here)

      -- Pyright: type checking only, let ruff own linting
      vim.lsp.config("pyright", {
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

      -- Ruff: linting + formatting diagnostics
      vim.lsp.config("ruff", {
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

      -- Rust: use clippy instead of plain cargo check for linting
      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            check = {
              command = "clippy",
              extraArgs = { "--all", "--", "-W", "clippy::all" },
            },
            cargo = {
              allFeatures = true,
            },
          },
        },
      })

      -- 5. Ensure servers are installed; mason-lspconfig auto-enables them via vim.lsp.enable()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "ruff", "rust_analyzer" },
      })
    end,
  },
}
