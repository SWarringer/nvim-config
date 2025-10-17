-- ~/.config/nvim/lua/plugins/snacks.lua
-----------------------------------------------------------
-- Snacks.nvim: Advanced Dashboard, Explorer, Git, etc.
-----------------------------------------------------------

return {
	{
		"folke/snacks.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		priority = 999,
		config = function()
			local snacks = require("snacks")

			-- Setup Snacks
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
						{ section = "keys", gap = 1, padding = 1 },
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
						{
							pane = 2,
							icon = " ",
							title = "Recent Files",
							section = "recent_files",
							indent = 2,
							padding = 1,
						},
						{
							pane = 2,
							icon = " ",
							title = "Projects",
							section = "projects",
							indent = 2,
							padding = 1,
						},
						{ section = "startup" },
					},
					preset = {
						entries = {
							{
								key = "e",
								label = "Explore files",
								action = function()
									snacks.explorer()
								end,
							},
							{
								key = "f",
								label = "Find File",
								action = function()
									require("telescope.builtin").find_files({
										prompt_title = "Find Lua Files",
										cwd = vim.fn.getcwd(),
										file_ignore_patterns = { "node_modules", ".git" },
										sorting_strategy = "ascending",
										attach_mappings = function(prompt_bufnr, map)
											local actions = require("telescope.actions")
											map("i", "<esc>", actions.close)
											return true
										end,
									})
								end,
							},
							{
								key = "n",
								label = "New File",
								action = function()
									local filename = vim.fn.input("New file name: ")
									if filename ~= "" then
										vim.cmd("edit " .. filename)
									end
								end,
							},
							{
								key = "p",
								label = "Projects",
								action = function()
									require("telescope").extensions.projects.projects()
								end,
							},
							{
								key = "r",
								label = "Restore Session",
								action = function()
									print("Restore previous session here")
								end,
							},
							{
								key = "q",
								label = "Quit",
								action = function()
									vim.cmd("qa")
								end,
							},
						},
					},
				},
				explorer = {
					layout = { layout = { position = "left" } },
					follow_file = true,
					tree = true,
					focus = "list",
					jump = { close = false },
					auto_close = false,
					show_hidden = true, -- show dotfiles by default (NOT WORKING ATM)
					toggles = {
						hidden = "h",
					},

					ignore = { "node_modules", ".git" }, -- still ignore large dirs
				},

				git = { enabled = true },
				rename = { enabled = true },
			})

			-- === THEME-DEPENDENT DASHBOARD HIGHLIGHTS ===
			local theme_colors = {}
			local ok_catppuccin, catppuccin = pcall(require, "catppuccin.palettes")
			local ok_pywal, pywal16 = pcall(require, "pywal16.colors")
			if ok_catppuccin then
				theme_colors.bg = vim.g.colors_name == "catppuccin"
						and vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Normal")), "bg")
					or "#1e1e2e"
				theme_colors.header = catppuccin.get_palette().lavender
				theme_colors.dir = catppuccin.get_palette().blue
				theme_colors.file = catppuccin.get_palette().text
			elseif ok_pywal then
				theme_colors.bg = pywal16.background
				theme_colors.header = pywal16.color4
				theme_colors.dir = pywal16.color1
				theme_colors.file = pywal16.foreground
			else
				-- default fallback
				theme_colors.bg = "#1e1e2e"
				theme_colors.header = "#f5c2e7"
				theme_colors.dir = "#89b4fa"
				theme_colors.file = "#cdd6f4"
			end

			vim.api.nvim_set_hl(0, "SnacksDashboardNormal", { bg = theme_colors.bg, fg = theme_colors.file })
			vim.api.nvim_set_hl(0, "header", { bg = theme_colors.bg, fg = theme_colors.header })
			vim.api.nvim_set_hl(0, "dir", { bg = theme_colors.bg, fg = theme_colors.dir })
			vim.api.nvim_set_hl(0, "file", { bg = theme_colors.bg, fg = theme_colors.file })

			-- Dashboard keybinding for explorer
			vim.keymap.set("n", "<leader>e", function()
				local ok, err = pcall(snacks.explorer)
				if not ok then
					print("Error opening Snacks explorer:", err)
				end
			end, { desc = "Toggle Snacks Explorer" })

			-- Show dashboard on startup
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					vim.defer_fn(function()
						local ok, err = pcall(snacks.dashboard)
						if not ok then
							print("Error opening Snacks dashboard:", err)
						end
					end, 100) -- 100ms delay
				end,
			})
		end,
	},
}
