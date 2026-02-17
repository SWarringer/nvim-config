return {
  -- Base LSP configuration
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local lspconfig = require("lspconfig")

      -- Set up basic LSP keymaps once a server attaches
      local on_attach = function(_, bufnr)
        local opts = { buffer = bufnr, silent = true }
      end

      -- Disable default virtual text; tiny-inline-diagnostic will handle inline display
      vim.diagnostic.config({
        virtual_text = false,
        float = { border = "rounded" }, -- optional, hover floats still work
      })

      -- Store on_attach globally so Mason auto-enabled servers can use it
      vim.g._global_lsp_on_attach = on_attach
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
        "clangd",
        "rust_analyzer",
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
      ensure_installed = {
        "black",
        "clang-format",
      },
      run_on_start = true,
    },
    dependencies = { "mason-org/mason.nvim" },
  },

  -- Autoformat on save
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "black" },
        c = { "clang_format" },
      },
      format_on_save = function()
        return { timeout_ms = 3000, lsp_fallback = true }
      end,
    },
    dependencies = { "mason-org/mason.nvim" },
  },

  -- ✨ Auto pairs (brackets, parentheses, quotes)
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      enable_check_bracket_line = true,
    },
  },

  -- ✨ Completion UI (Blink)
  {
    "Saghen/blink.cmp",
    version = "*",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      keymap = {
        ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
        ["<CR>"] = { "select_and_accept", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<PageDown>"] = { "scroll_documentation_down" },
        ["<PageUp>"] = { "scroll_documentation_up" },
      },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        menu = { border = "rounded", scrollbar = false },
        list = { selection = { preselect = false, auto_insert = true } },
        ghost_text = { enabled = true },
      },
      signature = { enabled = true },
      sources = { default = { "lsp", "path", "buffer" } },
    },
  },
}
