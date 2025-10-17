-- ~/.config/nvim/lua/plugins/lsp.lua
-----------------------------------------------------------
return {
  -- Mason core
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },


  -- 1️⃣ setup Mason-LSP
        -- mason_lsp.setup({
        -- ensure_installed = {
        --     "pyright",    -- Python
        --     "ts_ls",   -- TypeScript / JavaScript
        --     "lua_ls",     -- Lua (Neovim config)
        --     "html",       -- HTML
        --     "cssls",      -- CSS
        --     "jsonls",     -- JSON
        --     },
        -- })


  -- Mason + lspconfig
{
  "williamboman/mason-lspconfig.nvim",
  lazy = false,
  dependencies = { "mason.nvim", "neovim/nvim-lspconfig" },
  config = function()
    local lspconfig = require("lspconfig")
    local ok, mason_lsp = pcall(require, "mason-lspconfig")
    if not ok then
      vim.notify("mason-lspconfig not loaded", vim.log.levels.ERROR)
      return
    end

    -- Basic setup
    mason_lsp.setup()  -- no ensure_installed needed

    -- Handlers: only if setup_handlers exists
    if mason_lsp.setup_handlers then
      mason_lsp.setup_handlers({
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            on_attach = function(client, bufnr)
              local opts = { noremap = true, silent = true, buffer = bufnr }
              local map = vim.keymap.set
              map("n", "gd", vim.lsp.buf.definition, opts)
              map("n", "gr", vim.lsp.buf.references, opts)
              map("n", "K", vim.lsp.buf.hover, opts)
              map("n", "<leader>rn", vim.lsp.buf.rename, opts)
            end,
          })
        end,
      })
    end
  end,
},


  -- Lua helper
  {
    "folke/neodev.nvim",
    lazy = false,
    config = function()
      require("neodev").setup()
    end,
  },
}
