-- ~/.config/nvim/lua/plugins/telescope.lua
-----------------------------------------------------------
-- Telescope: fuzzy finder, search, pickers
-----------------------------------------------------------

return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
    lazy = false,
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git/" },
        },
      })

      local map = vim.keymap.set
      -- Keymaps for Telescope
      map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
      map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
      map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
      map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help tags" })
    end,
  },
  -- Harpoon: quick file navigation
{
  "ThePrimeagen/harpoon",
  dependencies = { "nvim-lua/plenary.nvim" },
  lazy = false,
  config = function()
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")
    local map = vim.keymap.set

    -- Add current file to Harpoon
    map("n", "<leader>ha", mark.add_file, { desc = "Harpoon add file" })
    -- Toggle Harpoon quick menu
    map("n", "<leader>hm", ui.toggle_quick_menu, { desc = "Harpoon menu" })
    -- Navigate files 1-4 quickly
    map("n", "<leader>h1", function() ui.nav_file(1) end, { desc = "Harpoon go to 1" })
    map("n", "<leader>h2", function() ui.nav_file(2) end, { desc = "Harpoon go to 2" })
    map("n", "<leader>h3", function() ui.nav_file(3) end, { desc = "Harpoon go to 3" })
    map("n", "<leader>h4", function() ui.nav_file(4) end, { desc = "Harpoon go to 4" })
  end,
},

-- Optional: project management
{
  "ahmedkhalf/project.nvim",
  lazy = false,
  config = function()
    require("project_nvim").setup({
      detection_methods = { "pattern" },
      patterns = { ".git", "Makefile", "package.json" },
    })

    -- Telescope integration
    require("telescope").load_extension("projects")
    vim.keymap.set("n", "<leader>fp", "<cmd>Telescope projects<cr>", { desc = "Projects" })
  end,
},


}
