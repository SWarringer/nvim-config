-----------------------------------------------------------
-- UI Polish: Statusline, Bufferline, Key hints, Noice
-----------------------------------------------------------

-- Helper: get lushwal theme colors
local function get_lushwal_colors()
  local ok, lushwal = pcall(require, "lushwal.colors")
  if ok then
    return lushwal()
  else
    -- fallback colors if lushwal isn't installed
    return {
      background = "#1e1e2e",
      color1 = "#ff0000",
      color2 = "#00ff00",
      color3 = "#0000ff",
      color4 = "#ffff00",
      color5 = "#ff00ff",
    }
  end
end

local theme = get_lushwal_colors()
local bg = tostring(theme.background)
local hex = function(c) return c and tostring(c) or nil end

return {
  -----------------------------------------------------------
  -- Lualine: Statusline
  -----------------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "oncomouse/lushwal.nvim",
      "rktjmp/lush.nvim",
      "rktjmp/shipwright.nvim",
    },
    config = function()
      local theme_name

      local has_lushwal = pcall(require, "lushwal")
      if has_lushwal then
        vim.g.lushwal_configuration = {
          transparent_background = false,
          compile_to_vimscript = true,
          terminal_colors = false,
          addons = { treesitter = true, native_lsp = true },
        }

        vim.cmd("LushwalCompile")
        vim.cmd.colorscheme("lushwal")
        vim.opt.cursorline = true

        -- CursorLine and keywords
        vim.api.nvim_set_hl(0, "CursorLine", { bg = hex(theme.background) })
        vim.api.nvim_set_hl(0, "Keyword", { fg = hex(theme.color2), bold = true })
        vim.api.nvim_set_hl(0, "Conditional", { fg = hex(theme.color5) })
        vim.api.nvim_set_hl(0, "@keyword", { fg = hex(theme.color2), bold = true })

        theme_name = "lushwal"
      else
        vim.cmd.colorscheme("catppuccin")
        vim.opt.cursorline = true
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

  -----------------------------------------------------------
  -- Bufferline
  -----------------------------------------------------------
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

  -----------------------------------------------------------
  -- Which-key: Keybinding hints
  -----------------------------------------------------------
  {
  "folke/which-key.nvim",
  lazy = false,
  config = function()
    local theme = get_lushwal_colors()
    local bg = tostring(theme.background)

    require("which-key").setup({
      plugins = { spelling = true },
      win = {
        border = "single",
      },
    })

    -- Apply lushwal colors manually after setup
    vim.schedule(function()
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = bg })
      vim.api.nvim_set_hl(0, "FloatBorder", { bg = bg, fg = bg })
    end)
  end,
},


  -----------------------------------------------------------
  -- Noice: Enhanced command line, notifications
  -----------------------------------------------------------
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
      -- Make notifications follow lushwal theme
      require("notify").setup({ background_colour = bg })

      -- Apply lushwal to Noice popups
      vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = bg })
      vim.api.nvim_set_hl(0, "NoicePopupmenu", { bg = bg })
      vim.api.nvim_set_hl(0, "NoicePopupmenuBorder", { bg = bg, fg = bg })

      require("noice").setup(opts)
    end,
  },
}
