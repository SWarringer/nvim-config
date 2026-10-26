-- Set the token path so codecompanion can find the Copilot token
vim.env["CODECOMPANION_TOKEN_PATH"] = vim.fn.expand("~/.config")

-- Use the work account token (SWarringerLumen) for codecompanion
local _cc_token = vim.trim(vim.fn.system([[sqlite3 ~/.config/github-copilot/auth.db "SELECT token_ciphertext FROM oauth_tokens WHERE user_login='SWarringerLumen' LIMIT 1;"]]))
if _cc_token and _cc_token ~= "" then
  vim.env["GITHUB_TOKEN"] = _cc_token
  vim.env["CODESPACES"] = "true"
end

local EMBEDDED_PROMPT = [[
You are assisting an experienced embedded software engineer.

General preferences:
- Prefer simple and maintainable solutions.
- Prefer minimal code changes over large refactors.
- Explain tradeoffs when proposing changes.
- Avoid introducing new dependencies unless they provide clear value.
- Act as a mentor and guide. Explain the reasoning behind recommendations so the engineer can learn from the process.
- Favor incremental improvements over large sweeping changes.
- Cite the files, functions, or documentation that support your conclusions.
- If anything is unclear, never make assumptions. Always ask for clarification.

When working with code:
- Read and understand surrounding code before proposing changes.
- Search the repository and relevant documentation before making assumptions.
- Follow existing project conventions.
- Follow existing project architecture and design patterns.
- Consider error handling, edge cases, maintainability, and testability.
- Clearly identify assumptions and uncertainties.
- Reference relevant documentation, standards, or source material found in the repository when applicable.

For C/C++ code:
- Watch for memory safety issues.
- Watch for integer conversion and overflow issues.
- Watch for concurrency, synchronization, and race conditions.
- Consider embedded constraints such as RAM usage, Flash usage, CPU utilization, startup time, and deterministic behavior.
- Prefer clear and predictable code over clever solutions.

When repository tools are available:
- Base conclusions on code and documentation found in the project whenever possible.

When web search tools are available:
- Search authoritative sources first.
- Prefer official documentation over blog posts.
- Include links to relevant documentation when possible.
- Clearly distinguish between information found online and information inferred from the repository.
]]

return {
  {
    "github/copilot.vim",
    init = function()
      vim.g.copilot_enabled = false
    end,
  },

  {
    "olimorris/codecompanion.nvim",
    version = "^19.0.0",

    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",

      {
        "ravitemer/codecompanion-history.nvim",
        dependencies = {
          "kkharji/sqlite.lua",
        },
      },
    },

    opts = {
      interactions = {
        chat = {
          adapter = "copilot",
          tools = {
            -- DuckDuckGo needs no API key; Jina Reader (r.jina.ai) fetches pages without one
            web_search = { opts = { adapter = "duckduckgo" } },
            fetch_webpage = { opts = { adapter = "jina" } },
          },
          opts = {
            -- Append our instructions to the default system prompt
            system_prompt = function(ctx)
              return ctx.default_system_prompt .. "\n" .. EMBEDDED_PROMPT
            end,
          },
        },
        inline = {
          adapter = "copilot",
        },
      },

      adapters = {
        http = {
          copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
              schema = {
                model = {
                  default = "claude-sonnet-5.5",
                },
              },
            })
          end,
        },
      },

      display = {
        chat = {
          window = {
            position = "right",
            width = 0.3,
          },
        },

        inline = {
          model = {
            default = "claude-sonnet-5.5",
          },
        },
      },

      opts = {
        log_level = "DEBUG",
      },
    },

    keys = {
      { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle Chat" },
      { "<leader>ca", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI Actions" },
      { "<leader>ci", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "Inline Prompt" },
      { "<leader>cA", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add to Chat" },
    },
  },

  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    opts = {
      preview = {
        filetypes = { "markdown", "codecompanion" },
        ignore_buftypes = {},
      },
    },
  },
}
