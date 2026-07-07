-- Set the token path so codecompanion can find the Copilot token
vim.env["CODECOMPANION_TOKEN_PATH"] = vim.fn.expand("~/.config")

-- Use the work account token (SWarringerLumen) for codecompanion
local _cc_token = vim.trim(vim.fn.system([[sqlite3 ~/.config/github-copilot/auth.db "SELECT token_ciphertext FROM oauth_tokens WHERE user_login='SWarringerLumen' LIMIT 1;"]]))
if _cc_token and _cc_token ~= "" then
  vim.env["GITHUB_TOKEN"] = _cc_token
  vim.env["CODESPACES"] = "true"
end

return {
  { "github/copilot.vim" },
  {
    "olimorris/codecompanion.nvim",
    version = "^19.0.0",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      interactions = {
        chat = {
          adapter = {
            name = "copilot",
            model = "claude-sonnet-4.5",
          },
        },
        inline = {
          adapter = "copilot",
        },
      },
      display = {
        chat = {
          window = {
            position = "right",
            width = 0.25,
          },
        },
      },
      opts = {
        log_level = "DEBUG",
      },
    },
    keys = {
      { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle Chat" },
      { "<leader>ca", "<cmd>CodeCompanionActions<cr>",     mode = { "n", "v" }, desc = "AI Actions" },
      { "<leader>ci", "<cmd>CodeCompanion<cr>",            mode = { "n", "v" }, desc = "Inline Prompt" },
      { "<leader>cA", "<cmd>CodeCompanionChat Add<cr>",    mode = "v",          desc = "Add to Chat" },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
  },
}
