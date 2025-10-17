local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Basic movements
map("n", "<leader>w", ":w<CR>", opts)
map("n", "<leader>q", ":q<CR>", opts)
map("n", "<leader>h", ":nohlsearch<CR>", opts)

-- Which-key registration (modern style)
local wk = require("which-key")

-- Keymaps (modern which-key style)
wk.add({
	-- Basic
	{ "<leader>w", "<cmd>w<cr>", desc = "Save" },
	{ "<leader>q", "<cmd>q<cr>", desc = "Quit" },
	{ "<leader>h", "<cmd>nohlsearch<cr>", desc = "No Highlight" },

	-- Buffers
	{ "<leader>bb", group = "Buffers" },
	{ "<leader>bbn", "<cmd>bn<cr>", desc = "Next Buffer" },
	{ "<leader>bbp", "<cmd>bp<cr>", desc = "Previous Buffer" },
	{ "<leader>bbd", "<cmd>bdelete<cr>", desc = "Delete Buffer" },

	-- Comment (avoids <c> conflicts)
	{ "<leader>cc", group = "Comment" },
	{ "<leader>ccl", "<cmd>lua require('Comment.api').toggle.linewise.current()<cr>", desc = "Toggle Line" },
	{ "<leader>ccb", "<cmd>lua require('Comment.api').toggle.blockwise.current()<cr>", desc = "Toggle Block" },

	-- Surround (avoids <Space> overlaps)
	{ "<leader>ss", group = "Surround" },
	{ "<leader>ssy", "<cmd>lua require('nvim-surround').add()<cr>", desc = "Add Surround" },
	{
		"<leader>ssyy",
		"<cmd>lua require('nvim-surround').add({motion='line'})<cr>",
		desc = "Add Surround Current Line",
	},
	{
		"<leader>ssyN",
		"<cmd>lua require('nvim-surround').add({new_line=true})<cr>",
		desc = "Add Surround Motion on New Lines",
	},
	{
		"<leader>ssyyN",
		"<cmd>lua require('nvim-surround').add({motion='line', new_line=true})<cr>",
		desc = "Add Surround Current Line on New Lines",
	},
	{ "<leader>ssd", "<cmd>lua require('nvim-surround').delete()<cr>", desc = "Delete Surround" },
	{ "<leader>ssc", "<cmd>lua require('nvim-surround').change()<cr>", desc = "Change Surround" },
	{ "<leader>ssvS", "<cmd>lua require('nvim-surround').add({mode='visual'})<cr>", desc = "Add Surround Visual" },

	-- Find / Files
	{ "<leader>ff", group = "Find" },
	{ "<leader>fff", "<cmd>Telescope find_files<cr>", desc = "Find File" },
	{ "<leader>ffg", "<cmd>Telescope live_grep<cr>", desc = "Grep Text" },
	{ "<leader>ffb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
	{ "<leader>ffh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },

	-- Explorer
	{
		"<leader>fe",
		function()
			require("snacks").explorer()
		end,
		desc = "Explorer",
	},

	-- Projects
	{ "<leader>fp", "<cmd>lua require('telescope').extensions.projects.projects()<cr>", desc = "Projects" },

	-- Git (avoids <g> conflicts)
	{ "<leader>gg", group = "Git" },
	{ "<leader>ggs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage Hunk" },
	{ "<leader>ggr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset Hunk" },
	{ "<leader>ggp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview Hunk" },
	{ "<leader>ggb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Blame Line" },

	-- Session / Restore
	{ "<leader>fr", "<cmd>lua require('persistence').load()<cr>", desc = "Restore Session" },

	-- Go to dashboard
	{
		"<leader>d",
		function()
			-- Close all floating windows
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local ok, cfg = pcall(vim.api.nvim_win_get_config, win)
				if ok and cfg.relative ~= "" then
					pcall(vim.api.nvim_win_close, win, true)
				end
			end

			-- Switch to a normal window if current is floating
			local cur_win = vim.api.nvim_get_current_win()
			local ok, cfg = pcall(vim.api.nvim_win_get_config, cur_win)
			if not ok or (cfg and cfg.relative ~= "") then
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local ok2, cfg2 = pcall(vim.api.nvim_win_get_config, win)
					if ok2 and cfg2.relative == "" then
						vim.api.nvim_set_current_win(win)
						break
					end
				end
			end

			-- Open dashboard
			local ok_snacks, snacks = pcall(require, "snacks")
			if ok_snacks then
				pcall(snacks.dashboard)
			else
				print("Snacks not available")
			end
		end,
		desc = "Open Snacks Dashboard",
	},
})
