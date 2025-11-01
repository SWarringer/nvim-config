local M = {}

function M.get_theme()
	local hex = function(c) return c and tostring(c) or nil end
	local function has_pywal() return vim.fn.executable("wal") == 1 end
	local lushwal_ok = pcall(require, "lushwal")

	if lushwal_ok and has_pywal() then
		vim.g.lushwal_configuration = {
			transparent_background = false,
			compile_to_vimscript = true,
			terminal_colors = true,
			addons = {
				treesitter = true,
				native_lsp = true,
				lualine = true,
				bufferline_nvim = false,
				which_key_nvim = true,
				telescope = true,
			},
		}
		vim.cmd("LushwalCompile")
		vim.cmd.colorscheme("lushwal")
		vim.opt.cursorline = true
		local colors = require("lushwal.colors")()
		vim.api.nvim_set_hl(0, "Keyword", { fg = hex(colors.color6) })
		vim.api.nvim_set_hl(0, "@keyword", { fg = hex(colors.color6) })
		vim.api.nvim_set_hl(0, "Conditional", { fg = hex(colors.color2) })
		vim.api.nvim_set_hl(0, "@conditional", { fg = hex(colors.color2) })
		--vim.api.nvim_set_hl(0, "@constant", { fg = hex(colors.color5) })
		--vim.api.nvim_set_hl(0, "Constant", { fg = hex(colors.color5) })
		vim.api.nvim_set_hl(0, "@structure", { fg = hex(colors.color5) })
		vim.api.nvim_set_hl(0, "structure", { fg = hex(colors.color5) })
		return colors, "lushwal"
	else
		vim.cmd.colorscheme("catppuccin")
		vim.opt.cursorline = false
		local colors = {
			background = "#1e1e2e",
			color1 = "#ff0000",
			color2 = "#00ff00",
			color3 = "#0000ff",
			color4 = "#ffff00",
			color5 = "#ff00ff",
		}
		return colors, "catppuccin"
	end
end

return M
