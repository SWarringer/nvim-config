# Neovim Config

Plugins install automatically via `lazy.nvim`. These external tools must be installed on the system:

## Required
- **Neovim ≥ 0.11**
- **git**
- **gcc/clang + make** – builds Treesitter parsers and `telescope-fzf-native`
- **ripgrep** (`rg`) – Telescope grep
- A **Nerd Font** – icons

## Language tools
- **clangd** – C LSP (optional `arm-none-eabi` toolchain for embedded)
- **Node.js + npm** – needed by Mason to install `pyright`
- **Python 3 + pip** – needed by Mason to install `black`

## Git
- **lazygit** – `<leader>gg`

## AI (Copilot / CodeCompanion)
- **GitHub Copilot** subscription + auth (`:Copilot setup`)
- **sqlite3** – reads the Copilot token from `~/.config/github-copilot/auth.db`

## Optional
- **pywal** (`wal`) – theme colors from `~/.cache/wal/colors.json` (falls back to rose-pine)
- **tmux** – `vim-tmux-navigator`
