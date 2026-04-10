-----------------------------------------------------------
-- UI Polish: Pywal theme with Catppuccin fallback
-----------------------------------------------------------
return {
  {
    'erdivartanovich/pywal.nvim',
    name = 'pywal',
    config = function()
      vim.defer_fn(function()
        local wal_file = vim.fn.expand("~/.cache/wal/colors.json")

        if vim.loop.fs_stat(wal_file) then
          vim.cmd.colorscheme("pywal")

          -- Extra delay for highlight override
          vim.defer_fn(function()
            local colors = require('pywal.core').get_colors()
            vim.cmd('hi CursorLine guibg=' .. colors.color2)
            vim.cmd('hi Comment guifg=' .. colors.color3)

            vim.cmd('hi NormalFloat guibg=' .. colors.background .. ' guifg=' .. colors.foreground)
            vim.cmd('hi FloatBorder guibg=' .. colors.background .. ' guifg=' .. colors.color4)
          end, 100)
        else
          vim.cmd.colorscheme("rose-pine")
        end
      end, 50)
    end,
  },

  -- Rose-pine as fallback (only dark mode)
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require("rose-pine").setup({
        variant = "dark",      -- Force dark mode only
        dark_variant = "main", -- main or moon for dark mode
        disable_background = false,
        disable_italics = false,
      })
    end,
  },

  -----------------------------------------------------------
  -- Lualine: Statusline
  -----------------------------------------------------------
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'erdivartanovich/pywal.nvim', 'rose-pine/neovim' },
    config = function()
      local wal_file = vim.fn.expand("~/.cache/wal/colors.json")
      local theme = vim.loop.fs_stat(wal_file) and 'pywal-nvim' or 'rose-pine'

      require('lualine').setup({
        options = {
          theme = theme,
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
  -- Which-key
  -----------------------------------------------------------
  {
    "folke/which-key.nvim",
    lazy = false,
    config = function()
      require("which-key").setup({ plugins = { spelling = true }, win = { border = "single" } })
    end,
  },

  -----------------------------------------------------------
  -- Noice
  -----------------------------------------------------------
  {
    "folke/noice.nvim",
    lazy = true,
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      views = {
        cmdline_popup = {
          position = { row = 5, col = "50%" },
        },
      },
    },
    config = function(_, opts)
      require("notify").setup({})
      require("noice").setup(opts)
    end,
  },


  -----------------------------------------------------------
  --  Persistence
  -------------------------------------------------------------
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- load before reading a buffer
    module = "persistence",
    config = function()
      require("persistence").setup({
        dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"), -- session directory
        options = { "buffers", "curdir", "tabpages", "winsize" },
      })
    end,
  },

  -----------------------------------------------------------
  -- Nvim-tree
  -----------------------------------------------------------
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    config = function()
      local nvim_tree = require("nvim-tree")
      local api = require("nvim-tree.api")

      nvim_tree.setup({
        disable_netrw = true,
        hijack_netrw = true,
        open_on_tab = false,
        hijack_cursor = true,
        update_cwd = true,
        view = { width = 30, side = "left", preserve_window_proportions = true },
        renderer = {
          add_trailing = false,
          group_empty = true,
          highlight_git = true,
          highlight_opened_files = "name",
          root_folder_modifier = ":t",
          icons = {
            webdev_colors = true,
            git_placement = "after",
            padding = " ",
            symlink_arrow = " ➛ ",
            show = {
              file = true,
              folder = true,
              folder_arrow = false,
              git = true
            },
            glyphs = {
              default = "",
              folder = {
                default = "",
                open = ""
              },
              git = {
                unstaged = "✗",
                staged = "✓",
                unmerged = "",
                renamed = "➜",
                untracked = "★"
              }
            }
          },
          indent_markers = {
            enable = true,
            inline_arrows = false,
            icons = { corner = "└", edge = "│", item = "│", bottom = "─", none = " " },
          },
        },
        filters = { dotfiles = true, custom = { "node_modules", ".git" } },
        actions = { open_file = { quit_on_open = false, resize_window = true } },
        on_attach = function(bufnr)
          local opts = function(desc)
            return { desc = desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end
          -- Navigation
          vim.keymap.set("n", "u", api.tree.change_root_to_parent, opts("Go to parent directory"))
          vim.keymap.set("n", "C", api.tree.change_root_to_parent, opts("CD up one directory"))
          vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open file or directory"))
          vim.keymap.set("n", "l", api.node.open.edit, opts("Open file or directory"))
          vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close directory"))
          vim.keymap.set("n", ".", api.tree.toggle_hidden_filter, opts("Toggle dotfiles"))
          -- File operations
          vim.keymap.set("n", "n", api.fs.create, opts("Create new file"))
          vim.keymap.set("n", "d", api.fs.remove, opts("Remove file/directory"))
          vim.keymap.set("n", "<Del>", api.fs.remove, opts("Remove file/directory"))
          -- Change cwd
          vim.keymap.set("n", "c", function()
            local node = api.tree.get_node_under_cursor()
            if node and node.type == "directory" then
              api.tree.change_root_to_node(node)
              vim.cmd("cd " .. node.absolute_path)
            else
              print("Not a directory")
            end
          end, opts("Change directory to selected folder"))
        end,
      })

      vim.keymap.set("n", "<leader>e", api.tree.toggle, { desc = "Toggle Nvim-Tree" })
      vim.opt.fillchars:append("eob: ")
    end,
  },

  {
    "folke/snacks.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    priority = 999,
    config = function()
      local snacks = require("snacks")
      snacks.setup({
        dashboard = {
          enabled = true,
          width = 80,
          pane_gap = 4,
          header = {
            " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
            " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
            " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
            " ██║╚██╗██║ ██╔══╝  ██║   ██║ ██║   ██║ ██║╚██╔╝██║",
            " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝ ██║ ╚═╝ ██║",
            " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝     ╚═╝",
          },
          sections = {
            { section = "header" },
            { section = "keys",  gap = 1, padding = 1 },
            {
              pane = 2,
              section = "terminal",
              cmd = "git status --short --branch --renames",
              enabled = function()
                local ok, root = pcall(snacks.git.get_root)
                return ok and root ~= nil
              end,
              height = 6,
              padding = 1,
              ttl = 5 * 60,
              indent = 3,
            },
            { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
            { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
            { section = "startup" },
          },
        },
        explorer = {
          layout = { layout = { position = "left" } },
          follow_file = true,
          tree = true,
          focus = "list",
          jump = { close = false },
          auto_close = false,
          show_hidden = true,
          toggles = { hidden = "h" },
          ignore = { "node_modules", ".git" },
        },
        git = { enabled = true },
        rename = { enabled = true },
      })

      vim.keymap.set("n", "<leader>t", function()
        local ok, err = pcall(function()
          snacks.terminal.toggle(nil, { win = { style = "floating" }, start_insert = true })
        end)
        if not ok then print("Error toggling Snacks terminal:", err) end
      end, { desc = "Toggle Snacks Terminal" })

      vim.keymap.set("n", "<leader>tc", function()
        local ok, err = pcall(function()
          local term = require("snacks").terminal.get()
          if term then term:close() end
        end)
        if not ok then print("Error closing Snacks terminal:", err) end
      end, { desc = "Close Snacks Terminal" })

      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.defer_fn(function()
            local ok, err = pcall(snacks.dashboard)
            if not ok then print("Error opening Snacks dashboard:", err) end
          end, 100)
        end,
      })
    end,
  },
}
