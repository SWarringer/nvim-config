-- ~/.config/nvim/lua/core/options.lua
-----------------------------------------------------------
-- General options
-----------------------------------------------------------

local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Tabs & Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Behavior
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.splitbelow = true
opt.splitright = true
opt.wrap = false

-- Performance
opt.updatetime = 250
opt.timeoutlen = 800

-- Appearance
opt.background = "dark"
opt.showmode = false

-- Encoding
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
