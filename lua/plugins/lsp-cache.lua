-- Keeps clangd/pyright working across `make clean` and container rebuilds.
-- :LspCache sync | status | edit | clean | log   (:help lsp-cache)
return {
  dir = "~/Dev/lsp-cache.nvim",
  name = "lsp-cache.nvim",
  lazy = false,
  opts = {
    clangd = {
      -- Used only for projects without cached toolchain headers.
      fallback_args = { "--query-driver=/usr/bin/arm-none-eabi-*" },
    },
  },
}
