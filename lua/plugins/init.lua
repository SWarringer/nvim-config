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

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
  },

  {
    "oncomouse/lushwal.nvim",
    cmd = { "LushwalCompile" },
    dependencies = {
      { "rktjmp/lush.nvim" },
      { "rktjmp/shipwright.nvim" },
    },
    lazy = false,
  },

  { import = "plugins.ui" },
  { import = "plugins.embedded" },
}
