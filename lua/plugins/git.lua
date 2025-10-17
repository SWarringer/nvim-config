-- ~/.config/nvim/lua/plugins/git.lua
-----------------------------------------------------------
-- Git integration: gitsigns, fugitive, diffview
-----------------------------------------------------------

return {
  -- gitsigns is already configured
  {
    "lewis6991/gitsigns.nvim",
    lazy = true,
    event = "BufReadPre",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
        current_line_blame = true,
        on_attach = function(bufnr)
          local map = vim.keymap.set
          local opts = { noremap = true, silent = true, buffer = bufnr }

          map("n", "]h", require("gitsigns").next_hunk, opts)
          map("n", "[h", require("gitsigns").prev_hunk, opts)
          map("n", "<leader>hs", require("gitsigns").stage_hunk, opts)
          map("n", "<leader>hr", require("gitsigns").reset_hunk, opts)
          map("n", "<leader>hS", require("gitsigns").stage_buffer, opts)
          map("n", "<leader>hu", require("gitsigns").undo_stage_hunk, opts)
          map("n", "<leader>hR", require("gitsigns").reset_buffer, opts)
          map("n", "<leader>hp", require("gitsigns").preview_hunk, opts)
        end,
      })
    end,
  },

  -- Fugitive for full git commands inside Neovim
  {
    "tpope/vim-fugitive",
    lazy = true,
  },

  -- Diffview for file/project diffs
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    lazy = true,
    config = function()
      require("diffview").setup()
    end,
  },
}
