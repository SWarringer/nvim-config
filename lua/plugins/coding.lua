-- ~/.config/nvim/lua/plugins/coding.lua
-----------------------------------------------------------
-- Editing Quality-of-Life: Comment, Autopairs, Flash, Surround
-----------------------------------------------------------

return {
  -- Comment.nvim: Easy commenting
  {
    "numToStr/Comment.nvim",
    lazy = false,
    config = function()
      require("Comment").setup({
        padding = true,
        sticky = true,
        toggler = { line = "<leader>cl", block = "<leader>cb" },
        opleader = { line = "<leader>c", block = "<leader>cb" },
      })
    end,
  },

  -- nvim-autopairs: Auto-close brackets, quotes, etc.
  {
    "windwp/nvim-autopairs",
    lazy = false,
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true, -- integrate with treesitter
        enable_check_bracket_line = false,
        fast_wrap = { map = "<M-e>" },
      })
    end,
  },

  -- nvim-surround: Add/change/delete surrounding chars easily
  {
    "kylechui/nvim-surround",
    version = "*", -- use latest stable
    lazy = false,
    config = function()
      require("nvim-surround").setup({
        mappings_style = "surround",
        keymaps = {
          insert = "<C-g>s",
          insert_line = "<C-g>S",
          normal = "<leader>sy",         -- add surround
          normal_cur = "<leader>syy",    -- add to current line
          normal_line = "<leader>sY",    -- add to entire line
          normal_cur_line = "<leader>sYY",
          visual = "<leader>vS",         -- visual mode add
          visual_line = "<leader>gS",    -- visual line mode add
          delete = "<leader>sd",         -- delete surround
          change = "<leader>sc",         -- change surround
        },
      })
    end,
  },

  -- Flash.nvim: Quick-motion like motions for jumps/search
  {
    "folke/flash.nvim",
    lazy = false,
    event = "VeryLazy",
    opts = {
      search = { multi_window = true, highlight = true },
      modes = { char = { jump_labels = true } },
    },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    },
  },
}
