return {
  -- Base LSP configuration
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      -- Diagnostics UI
      vim.diagnostic.config({
        virtual_text = false,
        float = { border = "rounded" },
      })
  
      -- on_attach
      local on_attach = function(_, bufnr)
        local opts = { buffer = bufnr, silent = true }
      end
  
      vim.g._global_lsp_on_attach = on_attach
  
      -- ✅ NEW API (no require("lspconfig"))
      -- clangd's `cmd` and pyright's pythonPath come from lsp-cache.nvim
      -- (lua/plugins/lsp-cache.lua).
      vim.lsp.config("clangd", {
        on_attach = on_attach,
      })

      -- ✅ Enable it
      vim.lsp.enable("clangd")
    end,
  },

  -- Tiny inline diagnostics plugin
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach", -- lazy-load when LSP attaches
    config = function()
      require("tiny-inline-diagnostic").setup({
        preset = "modern",
        transparent_bg = false,
        transparent_cursorline = true,
        hi = {
          error = "DiagnosticError",
          warn = "DiagnosticWarn",
          info = "DiagnosticInfo",
          hint = "DiagnosticHint",
          arrow = "NonText",
          background = "CursorLine",
          mixing_color = "Normal",
        },
        options = {
          show_source = { enabled = false },
          enable_on_insert = false,
          virt_texts = { priority = 2048 },
          severity = {
            vim.diagnostic.severity.ERROR,
            vim.diagnostic.severity.WARN,
            vim.diagnostic.severity.INFO,
            vim.diagnostic.severity.HINT,
          },
        },
      })
    end,
  },

  -- Mason + LSP bridge
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "pyright",
      },
      automatic_enable = true,
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },

  -- Mason tool installer (formatters etc.)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      run_on_start = true,
    },
    dependencies = { "mason-org/mason.nvim" },
  },

  -- ✨ Completion UI (Blink)
  {
    "Saghen/blink.cmp",
    version = "*",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      keymap = {
        ["<CR>"] = { "select_and_accept", "fallback" },
        ['<C-k>'] = { 'select_prev', 'fallback_to_mappings' },
        ['<C-j>'] = { 'select_next', 'fallback_to_mappings' },
        ['<C-K>'] = { 'select_prev', 'fallback' },
        ['<C-J>'] = { 'select_next', 'fallback' },
        ["<Down>"] = { "select_next", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<PageDown>"] = { "scroll_documentation_down" },
        ["<PageUp>"] = { "scroll_documentation_up" },
      },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        menu = { border = "rounded", scrollbar = false },
        list = { selection = { preselect = false, auto_insert = false } },
        ghost_text = { enabled = true },
      },
      signature = { enabled = false },
      sources = { default = { "lsp", "path", "buffer" } },
    },
  },
}
