return {
  { "alex-popov-tech/store.nvim", dependencies = { "OXY2DEV/markview.nvim" }, opts = {},cmd = "Store"},
  { "tpope/vim-fugitive", event = "VeryLazy" },
  { 'windwp/nvim-autopairs' },
  { "bngarren/checkmate.nvim", ft = "markdown", opts = {files = {"*.md","**/todo.md","project/todo.md","/absolute/path.md", }}},
  { "nvzone/typr", dependencies = "nvzone/volt", opts = {}, cmd = { "Typr", "TyprStats" },}
}
