vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Save file
vim.keymap.set("n", "<leader>w", ":write<CR>", { desc = "Save" })

-- Window navigation
vim.keymap.set('n', '<Tab>', '<C-w>w', { noremap = true, silent = true, desc = "Next window" })
vim.keymap.set('n', '<S-Tab>', '<C-w>W', { noremap = true, silent = true, desc = "Prev window" })

-- Search centering
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev search" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })

-- Paste without overwriting register
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste" })

-- Buffer navigation
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buf" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Prev buf" })

-- Window moves
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Right" })

-- Splits
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Vertical Split" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Horizontal Split" })
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Height +" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Height -" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Width -" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Width +" })
vim.keymap.set("n", "<leader>q", ":close<CR>", { desc = "Close split" })

-- Move lines (Normal)
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move selected down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move selected up" })

-- Move lines (Visual)
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selected down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selected up" })
