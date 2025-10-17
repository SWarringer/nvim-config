-- ~/.config/nvim/init.lua

vim.g.mapleader = " "
vim.g.maplocalleader = " "
-----------------------------------------------------------
-- Bootstrapping Lazy.nvim
-----------------------------------------------------------

--require("core.snacks_fix")  

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  print("Installing lazy.nvim...")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-----------------------------------------------------------
-- Load core config
-----------------------------------------------------------
require("core.options")

-----------------------------------------------------------
-- Load plugins via lazy.nvim
-----------------------------------------------------------
require("lazy").setup("plugins", {
  defaults = { lazy = true },
  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = true }, -- auto-check for plugin updates
})

require("core.keymaps")