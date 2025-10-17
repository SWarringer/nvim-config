return {
  -- Required dependency
  { "nvim-lua/plenary.nvim", lazy = true },

  -- Icon support
  { "nvim-tree/nvim-web-devicons", lazy = true },
  
  -- LSP, completion, formatting
  { import = "plugins.lsp" },
  { import = "plugins.completion" },
  { import = "plugins.formatting" },

  -- IDE Features
  { import = "plugins.treesitter" },
  { import = "plugins.telescope" },
  { import = "plugins.git" },

  -- Theme plugins
  {
    "uZer/pywal16.nvim",
      config = function()
      vim.cmd.colorscheme("pywal16")
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
  },

  { import = "plugins.ui" },
  { import = "plugins.embedded" },
}
