return {
	-- Base LSP configuration
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local lspconfig = require("lspconfig")

			-- Set up basic LSP keymaps once a server attaches
			local on_attach = function(_, bufnr)
				local opts = { buffer = bufnr, silent = true }
				local map = vim.keymap.set
				map("n", "gd", vim.lsp.buf.definition, opts)
				map("n", "gD", vim.lsp.buf.declaration, opts)
				map("n", "gr", vim.lsp.buf.references, opts)
				map("n", "gi", vim.lsp.buf.implementation, opts)
				map("n", "K", vim.lsp.buf.hover, opts)
				map("n", "<leader>rn", vim.lsp.buf.rename, opts)
				map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
			end

			-- Optionally tweak diagnostic style
			vim.diagnostic.config({
				virtual_text = false,
				float = { border = "rounded" },
			})

			-- 🔍 Show diagnostic info automatically when hovering on an error
			vim.api.nvim_create_autocmd("CursorHold", {
				callback = function()
					vim.diagnostic.open_float(nil, { focus = false, border = "rounded" })
				end,
			})

			-- Store on_attach globally so Mason auto-enabled servers can use it
			vim.g._global_lsp_on_attach = on_attach
		end,
	},

	-- Mason + LSP bridge
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"clangd",
				"rust_analyzer",
				"pyright",
			},
			automatic_enable = true,
		},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
	},

	-- Mason tool installer (formatters etc.)
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = {
				"black",
				"isort",
				"clang-format",
				"rustfmt",
			},
			run_on_start = true,
		},
		dependencies = { "mason-org/mason.nvim" },
	},

	-- Autoformat on save
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				python = { "black", "isort" },
				c = { "clang_format" },
				rust = { "rustfmt" },
			},
			format_on_save = function()
				return { timeout_ms = 3000, lsp_fallback = true }
			end,
		},
		dependencies = { "mason-org/mason.nvim" },
	},

	-- ✨ Auto pairs (brackets, parentheses, quotes)
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter", -- lazy-load in insert mode
		opts = {
			check_ts = true, -- use treesitter for smarter pairing
			enable_check_bracket_line = true,
		},
	},

	-- ✨ Completion UI (Blink)
	{
		"Saghen/blink.cmp",
		version = "*",
		dependencies = { "neovim/nvim-lspconfig" },
		opts = {
			keymap = { preset = "enter" }, -- tab + enter support
			completion = {
				accept = { auto_brackets = { enabled = true } },
				menu = {
					border = "rounded",
					scrollbar = false,
				},
			},
			signature = { enabled = true },
			sources = {
				default = { "lsp", "path", "buffer" },
			},
		},
	},
}
