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
	-----------------------------------------------------------
	-- Nvim-tree + Snacks integration
	-----------------------------------------------------------
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = false,
		config = function()
			local nvim_tree = require("nvim-tree")
			local api = require("nvim-tree.api")

			-- Nvim-tree setup
			nvim_tree.setup({
				disable_netrw = true,
				hijack_netrw = true,
				open_on_tab = false,
				hijack_cursor = true,
				update_cwd = true,
				view = {
					width = 30,
					side = "left",
					preserve_window_proportions = true,
				},
				renderer = {
					add_trailing = false,
					group_empty = true,
					highlight_git = true,
					highlight_opened_files = "name",
					root_folder_modifier = ":t",
					icons = {
						show = {
							file = true,
							folder = true,
							folder_arrow = true,
							git = true,
						},
						glyphs = {
							default = "",
							symlink = "",
							folder = {
								arrow_closed = "",
								arrow_open = "",
								default = "",
								open = "",
								empty = "",
								empty_open = "",
								symlink = "",
								symlink_open = "",
							},
							git = {
								unstaged = "✗",
								staged = "✓",
								unmerged = "",
								renamed = "➜",
								untracked = "★",
								deleted = "",
								ignored = "◌",
							},
						},
					},
					indent_markers = {
						enable = true,
						inline_arrows = true,
						icons = {
							corner = "└",
							edge = "│",
							item = "│",
							bottom = "─",
							none = " ",
						},
					},
				},
				filters = {
					dotfiles = true, -- hidden by default
					custom = { "node_modules", ".git" },
				},
				actions = {
					open_file = {
						quit_on_open = false,
						resize_window = true,
					},
				},
				on_attach = function(bufnr)
					local opts = function(desc)
						return { desc = desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
					end

					-- Navigation
					vim.keymap.set("n", "u", api.tree.change_root_to_parent, opts("Go to parent directory"))
					vim.keymap.set("n", "C", api.tree.change_root_to_parent, opts("CD up one directory"))
					vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open file or directory"))
					vim.keymap.set("n", ".", api.tree.toggle_hidden_filter, opts("Toggle dotfiles"))

					-- File operations
					vim.keymap.set("n", "n", api.fs.create, opts("Create new file"))
					vim.keymap.set("n", "d", api.fs.remove, opts("Remove file/directory"))
					vim.keymap.set("n", "<Del>", api.fs.remove, opts("Remove file/directory"))

					-- Change Neovim cwd to the highlighted directory
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

			-- Global toggle mapping
			vim.keymap.set("n", "<leader>e", api.tree.toggle, { desc = "Toggle Nvim-Tree" })

			-- Remove ~ signs from empty lines
			vim.opt.fillchars:append("eob: ")
		end,
	}

	,
	{
		"folke/snacks.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		priority = 999,
		config = function()
			local snacks = require("snacks")

			-- Snacks setup
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

			-- Snacks terminal keymaps
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

			-- Show dashboard on startup
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
