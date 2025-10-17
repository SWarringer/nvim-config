-----------------------------------------------------------
-- UI Polish: Statusline, Bufferline, Key hints, Noice
-----------------------------------------------------------

return {
  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local theme_name

      -- Try loading pywal16
      local has_pywal, pywal16 = pcall(require, "pywal16")
      if has_pywal then
        pywal16.setup()
        vim.cmd.colorscheme("pywal16")
        theme_name = "pywal16-nvim"
      else
        -- Fallback to catppuccin
        vim.cmd.colorscheme("catppuccin")
        theme_name = "catppuccin"
      end

      require("lualine").setup({
        options = {
          theme = theme_name,
          section_separators = "",
          component_separators = "",
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          numbers = "none",
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          left_trunc_marker = "",
          right_trunc_marker = "",
          max_name_length = 18,
          max_prefix_length = 15,
          tab_size = 18,
          show_buffer_close_icons = true,
          show_close_icon = false,
          enforce_regular_tabs = false,
          always_show_bufferline = true,
        },
      })
    end,
  },

  -- Which-key: Keybinding hints
  {
    "folke/which-key.nvim",
    lazy = false,
    config = function()
      require("which-key").setup({
        plugins = { spelling = true },
        win = { border = "single" },
      })
    end,
  },

  -- Noice: Enhanced command line, notifications
  {
    "folke/noice.nvim",
    lazy = true,
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
    config = function(_, opts)
      -- Get current Normal highlight's background for theme-aware notify
      local hl = vim.api.nvim_get_hl_by_name("Normal", true)
      local bg_hex = hl.background and string.format("#%06x", hl.background) or "#000000"

      require("notify").setup({
        background_colour = bg_hex,
      })

      require("noice").setup(opts)
    end,
},
}
