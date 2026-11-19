-- Keeps clangd/pyright working across `make clean` and container rebuilds.
-- :LspCache sync | status | edit | clean | log   (:help lsp-cache)
return {
  "SWarringer/lsp-cache.nvim",
  -- Use the ~/Dev checkout when present, otherwise clone from GitHub
  -- (see `dev` in config/lazy.lua).
  dev = true,
  lazy = false,
  opts = {
    clangd = {
      -- Used only for projects without cached toolchain headers.
      fallback_args = { "--query-driver=/usr/bin/arm-none-eabi-*" },
    },
  },
}
