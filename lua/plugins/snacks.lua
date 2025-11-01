return {
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
     
    vim.keymap.set("n", "<leader>h", function()
      local ok, err = pcall(function()
        require("snacks").dashboard()
      end)
      if not ok then print("Error opening Snacks dashboard:", err) end
    end, { desc = "Open Snacks Dashboard" })

    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        vim.defer_fn(function()
          local ok, err = pcall(snacks.dashboard)
          if not ok then print("Error opening Snacks dashboard:", err) end
        end, 100)
      end,
    })
  end,
}


