-- ~/.config/nvim/lua/plugins/formatting.lua
-----------------------------------------------------------
-- Formatting / Linting
-----------------------------------------------------------

return {
  {
    "stevearc/conform.nvim",
    lazy = false,
    config = function()
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "black" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
        },
      })

      -- Optional: format on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function()
          conform.format({ async = false })
        end,
      })
    end,
  },
}
