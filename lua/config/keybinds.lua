vim.g.mapleader = " "
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)
-- Move between buffers with Tab / Shift-Tab
vim.keymap.set("n", "<Tab>", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { silent = true })
-- Close current buffer (safe close, keeps layout)
vim.keymap.set("n", "<C-w>", ":bdelete<CR>", { silent = true })
-- Keep a history of closed buffers
local last_closed = nil

vim.api.nvim_create_autocmd("BufDelete", {
	callback = function(args)
		last_closed = args.buf
	end,
})

-- Reopen last closed buffer (Ctrl+Shift+T)
vim.keymap.set("n", "<C-S-T>", function()
	if last_closed and vim.api.nvim_buf_is_valid(last_closed) then
		local name = vim.api.nvim_buf_get_name(last_closed)
		if name ~= "" then
			vim.cmd("edit " .. vim.fn.fnameescape(name))
		else
			vim.notify("No buffer to reopen", vim.log.levels.INFO)
		end
	else
		vim.notify("No recently closed buffer", vim.log.levels.INFO)
	end
end, { silent = true })
-----------------------------------------------------------
-- Window Navigation: Leader + Tab and tmux-style keys
-----------------------------------------------------------

-- Cycle windows with <leader><Tab>
vim.keymap.set({ "n", "t" }, "<leader><Tab>", function()
	if vim.fn.mode() == "t" then
		vim.cmd("stopinsert")
	end
	vim.cmd("wincmd w")
	-- if next window is a terminal, jump right into insert
	if vim.bo.buftype == "terminal" then
		vim.cmd("startinsert")
	end
end, { desc = "Cycle windows (like Alt+Tab)", silent = true })

-- tmux-style navigation (Ctrl + hjkl)
local function map_nav(mode, lhs, rhs)
	vim.keymap.set(mode, lhs, function()
		if vim.fn.mode() == "t" then
			vim.cmd("stopinsert")
		end
		vim.cmd("wincmd " .. rhs)
		if vim.bo.buftype == "terminal" then
			vim.cmd("startinsert")
		end
	end, { silent = true, desc = "Move to window " .. rhs })
end

map_nav({ "n", "t" }, "<C-h>", "h")
map_nav({ "n", "t" }, "<C-j>", "j")
map_nav({ "n", "t" }, "<C-k>", "k")
map_nav({ "n", "t" }, "<C-l>", "l")
