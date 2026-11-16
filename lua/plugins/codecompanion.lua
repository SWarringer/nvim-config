return {
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
          adapter = "claude_code",
          tools = {
            -- DuckDuckGo needs no API key; Jina Reader (r.jina.ai) fetches pages without one
            web_search = { opts = { adapter = "duckduckgo" } },
            fetch_webpage = { opts = { adapter = "jina" } },
          },
        },
      },

      adapters = {
        -- Claude Code via the Agent Client Protocol (chat buffer).
        -- Requires `claude-agent-acp` on PATH. Auth reuses your existing
        -- `claude` login (~/.claude/.credentials.json), so no secret lives here.
        -- Optionally set CLAUDE_CODE_OAUTH_TOKEN in your shell env (never in this file).
        acp = {
          claude_code = function()
            return require("codecompanion.adapters").extend("claude_code", {
              env = {
                -- The default (a plain string) is passed through literally when the
                -- env var is unset, sending a bogus token. A function returns nil instead,
                -- so the agent falls back to the `claude` login.
                CLAUDE_CODE_OAUTH_TOKEN = function()
                  return os.getenv("CLAUDE_CODE_OAUTH_TOKEN")
                end,
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
      },

      extensions = {
        history = {
          enabled = true,
          opts = {
            auto_save = true,
            -- Title generation needs an HTTP adapter; Claude Code (ACP) isn't supported
            auto_generate_title = false,
          },
        },
      },
    },

    keys = {
      { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle Chat" },
      { "<leader>ca", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI Actions" },
      { "<leader>cA", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add to Chat" },
      { "<leader>cn", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "New Chat" },
      { "<leader>cs", "<cmd>CodeCompanionHistory<cr>", mode = "n", desc = "Browse/Select Chats (history)" },
      { "<leader>cl", "<cmd>CodeCompanionSummaries browse<cr>", mode = "n", desc = "Browse Summaries" },
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
