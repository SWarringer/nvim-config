-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8

-- Indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.keymap.set({ "n", "i", "v" }, "<Esc>", "<Esc>:nohlsearch<CR>", { noremap = true, silent = true })

-- Visual
vim.opt.termguicolors = true

-- File handling
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.updatetime = 300
vim.opt.autoread = true

-- Behavior
vim.opt.hidden = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"


