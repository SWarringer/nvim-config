return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    build = "make tiktoken",

    opts = {
      model = "claude-sonnet-4.6",
      temperature = 0.2,

      window = {
        layout = "vertical",
        width = 0.25,
        side = "right",
      },

      system_prompt = [[
You are a senior software engineer helping with code understanding,
debugging, and system design.

Behavior rules:
- Prefer explanations, reasoning, and structured thinking
- Focus on intent, edge cases, and potential issues
- Discuss tradeoffs when suggesting approaches
- DO NOT immediately write full implementations unless explicitly asked
- Avoid unnecessary fluff lines like congratulations, complementing thinking and such. Strait to business is preferred.

Important:
- If the request is ambiguous or missing context, ask clarifying questions first
- Do NOT make assumptions when unsure—seek clarification instead
]],

      prompts = {
        Explain = "Explain this code step by step. Include assumptions and edge cases.",
        Review = "Review this code. Identify bugs, unclear logic, and suggest improvements.",
        Debug = "Help debug this. Suggest possible causes and how to investigate.",
        Strategy = "Suggest approaches and design strategies. Do NOT write full implementations.",
      },
    },

    config = function(_, opts)
      local chat = require("CopilotChat")
      chat.setup(opts)

      -- =========================
      -- Core Keymaps
      -- =========================

      vim.keymap.set("v", "<leader>ce", function()
        chat.ask("Explain this code")
      end, { desc = "Explain code" })

      vim.keymap.set("v", "<leader>cr", function()
        chat.ask("Review this code")
      end, { desc = "Review code" })

      vim.keymap.set("v", "<leader>cd", function()
        chat.ask("Help debug this")
      end, { desc = "Debug code" })

      vim.keymap.set("n", "<leader>cs", function()
        chat.ask("Suggest an approach. Do not write full code.")
      end, { desc = "Strategy help" })

      -- =========================
      -- Chat Window Control
      -- =========================

      vim.keymap.set("n", "<leader>cc", function()
        chat.toggle()
      end, { desc = "Toggle CopilotChat" })


      -- =========================
      -- Model Picker
      -- =========================

      vim.keymap.set("n", "<leader>cM", function()
        local models = {
          "claude-haiku-4.5",
          "claude-sonnet-4.6",
          "claude-sonnet-4.5",
          "claude-opus-4.5",
          "claude-opus-4.6",
          "claude-opus-4.7",
          "claude-opus-4.8",
        }

        vim.ui.select(models, {
          prompt = "Select Copilot model:",
        }, function(choice)
          if choice then
            chat.config.model = choice
            vim.notify("Copilot model: " .. choice)
          end
        end)
      end, { desc = "Select Copilot model" })

      -- =========================
      -- Show Active Model
      -- =========================

      vim.api.nvim_create_autocmd("User", {
        pattern = "CopilotChatOpened",
        callback = function()
          vim.notify(
            "CopilotChat using model: " .. chat.config.model,
            vim.log.levels.INFO
          )
        end,
      })

      -- =========================
      -- Context Features (Agent-like)
      -- =========================

      -- Analyze current file
      vim.keymap.set("n", "<leader>cf", function()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        chat.ask("Analyze this file:\n\n" .. table.concat(lines, "\n"))
      end, { desc = "Analyze file" })

      -- Analyze current function (treesitter required)
      vim.keymap.set("n", "<leader>cF", function()
        local node = vim.treesitter.get_node()
        while node and node:type() ~= "function_definition" do
          node = node:parent()
        end

        if not node then
          vim.notify("No function found", vim.log.levels.WARN)
          return
        end

        local start_row, _, end_row, _ = node:range()
        local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false)

        chat.ask("Analyze this function:\n\n" .. table.concat(lines, "\n"))
      end, { desc = "Analyze function" })

      -- Analyze all open buffers
      vim.keymap.set("n", "<leader>cB", function()
        local buffers = vim.api.nvim_list_bufs()
        local combined = {}

        for _, buf in ipairs(buffers) do
          if vim.api.nvim_buf_is_loaded(buf) then
            local name = vim.api.nvim_buf_get_name(buf)
            if name ~= "" then
              local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
              table.insert(combined, "File: " .. name)
              table.insert(combined, table.concat(lines, "\n"))
              table.insert(combined, "\n\n")
            end
          end
        end

        chat.ask("Analyze these files without text output, then ask the user for instructions\n\n" .. table.concat(combined, "\n"))
      end, { desc = "Analyze buffers" })
    end,
  },
}
