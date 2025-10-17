return {
  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    lazy = false,
    priority = 1000,
    config = function()
      local parsers = require("nvim-treesitter.parsers").get_parser_configs()
      local mason_lspconfig_ok, mason_map = pcall(require, "mason-lspconfig.mappings.server")
      local ensure_installed = {}

      if mason_lspconfig_ok then
        for _, lsp in ipairs({ "pyright", "tsserver", "sumneko_lua" }) do
          local parser_name = mason_map.lsp_to_parser[lsp]
          if parser_name and not vim.tbl_contains(ensure_installed, parser_name) then
            table.insert(ensure_installed, parser_name)
          end
        end
      end

      require("nvim-treesitter.configs").setup({
        ensure_installed = ensure_installed,
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<leader>sn",
            node_incremental = "<leader>sr",
            node_decremental = "<leader>sm",
            scope_incremental = "<leader>sc",
          },
        },
        textobjects = {
          select = {
            enable = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
        },
      })
    end,
  },
}
