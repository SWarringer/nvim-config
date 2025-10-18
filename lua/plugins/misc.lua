-- ~/.config/nvim/lua/plugins/misc.lua
-----------------------------------------------------------
-- Persistence & Refactoring
-----------------------------------------------------------

return {
  -- Session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- load before opening a buffer
    config = function()
      require("persistence").setup({
        dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"),
        options = { "buffers", "curdir", "tabpages", "winsize" },
      })
    end,
  },

  -- TODO / FIXME highlighting
  {
    "folke/todo-comments.nvim",
    lazy = true,
    event = "BufReadPost",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup({
        signs = true,
        keywords = {
          FIX = { icon = "", color = "error" },
          TODO = { icon = "", color = "info" },
          HACK = { icon = "", color = "warning" },
          NOTE = { icon = "", color = "hint" },
        },
        highlight = { multiline = true, before = "", after = "" },
      })
    end,
  },

  -- Trouble: Diagnostics & lists
  {
    "folke/trouble.nvim",
    lazy = true,
    dependencies = "nvim-tree/nvim-web-devicons",
    cmd = { "TroubleToggle", "Trouble" },
    config = function()
      require("trouble").setup({
        height = 10,
        icons = true,
        mode = "document_diagnostics",
        fold_open = "",
        fold_closed = "",
        auto_open = false,
        auto_close = true,
      })
    end,
  },

  -- Aerial: Code outline
  {
    "stevearc/aerial.nvim",
    lazy = true,
    cmd = "AerialToggle",
    config = function()
      require("aerial").setup({
        backends = { "lsp", "treesitter", "markdown" },
        layout = { min_width = 30, max_width = 50, default_direction = "right" },
      })
    end,
  },
  {
    "nvzone/typr",
    dependencies = "nvzone/volt",
    opts = {},
    cmd = { "Typr", "TyprStats" },
  },
}
