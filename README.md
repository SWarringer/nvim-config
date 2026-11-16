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

## AI (Claude / CodeCompanion)
- **Claude Code** (`claude`), logged in via `claude` (Pro/Max/Team/Enterprise)
- **claude-agent-acp** on `PATH` – ACP bridge used by the chat buffer (`npm i -g @agentclientprotocol/claude-agent-acp`)
- **sqlite3** – used by `codecompanion-history.nvim` to store chats
- **Instructions** – CodeCompanion can't send a system prompt over ACP, so the prompt lives in
  `ai/embedded-prompt.md` and is loaded by Claude Code via `~/.claude/CLAUDE.md`:
  ```sh
  echo '@~/.config/nvim/ai/embedded-prompt.md' >> ~/.claude/CLAUDE.md
  ```

## Optional
- **pywal** (`wal`) – theme colors from `~/.cache/wal/colors.json` (falls back to rose-pine)
- **tmux** – `vim-tmux-navigator`
