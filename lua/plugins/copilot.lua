return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "copilot-chat" } },
    },
    build = "make tiktoken",

    opts = {
      model = "claude-sonnet-4.6",
      temperature = 0.2,
      auto_insert_mode = false,

      -- ✅ safe + powerful
      trusted_tools = { "file", "glob", "grep", "query", "edit", "bash", "gitdiff" },

      window = {
        layout = "float",
        width = 110,
        height = 32,
        border = "rounded",
      },

      system_prompt = [[

        You are a senior engineer helping a junior developer learn.
        
        Rules:
        - Explain reasoning before giving answers
        - Prefer guiding over solving
        - Do NOT provide full implementations unless explicitly requested
        - When possible, suggest what the user should try themselves
        - Highlight tradeoffs and edge cases
        - Be critical and point out potential mistakes
        
        Assume the goal is understanding, not speed.
        ]],
    },

    config = function(_, opts)
      local chat = require("CopilotChat")
      chat.setup(opts)

      -- =========================
      -- 🧠 SMART CONTEXT SYSTEM
      -- =========================

      local function get_context_files()
        local files = {}
        local cwd = vim.fn.getcwd()

        -- local tool context
        local local_ctx = cwd .. "/.project_context.md"
        if vim.fn.filereadable(local_ctx) == 1 then
          table.insert(files, local_ctx)
        end

        -- global (walk upwards)
        local global_ctx = vim.fn.findfile(".project_context.md", ".;")
        if global_ctx ~= "" then
          table.insert(files, global_ctx)
        end

        return files
      end

      local function with_context(prompt)
        local ctx_files = get_context_files()
      
        -- ✅ detect if caller already specifies buffers
        local has_buffer = prompt:match("#buffer:")
          or prompt:match("#gitdiff:")
      
        -- ✅ Define what files are relevant
        local source_patterns = "src/**/*.c include/**/*.h CMakeLists.txt prj.conf README.md"
      
        -- ✅ Define what to ignore
        local ignore_dirs = "build/, .cache/, .git/, zephyr/, modules/"
      
        local result = prompt
          .. "\n\n@copilot"
      
        -- ✅ only inject active buffer if nothing else is specified
        if not has_buffer then
          result = result .. "\n#buffer:active"
        end
      
        result = result
          .. "\n\nWhen exploring the project:"
          .. "\n- Focus on: " .. source_patterns
          .. "\n- Ignore: " .. ignore_dirs
      
        for _, file in ipairs(ctx_files) do
          result = result .. "\n#file:" .. file
        end
      
        return result
      end

      local function ask(prompt, extra)
        chat.ask(with_context(prompt), extra or {})
      end

      -- =========================
      -- 🚀 CORE WORKFLOW
      -- =========================
      
      -- ⭐ MAIN ENTRY POINT (guided, learning-focused)
      vim.keymap.set("n", "<leader>ca", function()
        local input = vim.fn.input("Ask (why/how/what): ")
        if input ~= "" then
          ask([[
      Answer as a mentor. Prioritize explanation and reasoning.
      
      Question:
      ]] .. input)
        end
      end, {
        desc = "Ask (guided): reasoning-first help with file + project context",
      })
      
      -- Explain (file)
      vim.keymap.set("n", "<leader>ce", function()
        ask("/Explain")
      end, {
        desc = "Explain current file (intent, flow, edge cases)",
      })
      
      -- Explain (selection)
      vim.keymap.set("v", "<leader>ce", function()
        ask("/Explain #selection")
      end, {
        desc = "Explain selected code",
      })
      
      -- Review
      vim.keymap.set("n", "<leader>cr", function()
        ask("/Review")
      end, {
        desc = "Review code: bugs, edge cases, clarity improvements",
      })
      
      -- Debug (deep / root cause)
      vim.keymap.set("n", "<leader>cd", function()
        ask([[
      Find the ROOT CAUSE of the issue.
      
      Steps:
      1. Trace execution
      2. Identify failure point
      3. Explain why
      4. Suggest fixes with tradeoffs
      ]])
      end, {
        desc = "Debug deeply: find root cause + reasoning",
      })
      
      -- Architecture (multi-buffer)
      vim.keymap.set("n", "<leader>cA", function()
        ask([[
      #buffer:listed
      
      Analyze architecture:
      Focus on structure, coupling, scalability.
      ]])
      end, {
        desc = "Analyze architecture across open buffers",
      })
      -- Project overview
      vim.keymap.set("n", "<leader>cB", function()
        ask([[
      #buffer:listed
      
      Summarize this codebase and ask what to explore next
      ]])
      end, {
        desc = "Project overview: summarize + propose exploration",
      })
      vim.keymap.set("n", "<leader>cR", function()
        ask([[
      Analyze this project:
      
      1. Identify main components
      2. Summarize structure
      3. Highlight key files
      
      Keep it concise.
      ]])
      end, {
        desc = "Analyze project root (auto-filtered)",
      })
      -- Git debugging (changes only)
      vim.keymap.set("n", "<leader>cg", function()
        ask([[
      #gitdiff:staged

      Find root cause of issues introduced by these changes
      ]])
      end, {
        desc = "Debug staged changes (git diff analysis)",
      })

      -- Fix
      vim.keymap.set({ "n", "v" }, "<leader>cf", function()
        ask("/Fix")
      end, {
        desc = "Fix bugs in current buffer/selection",
      })

      -- Tests
      vim.keymap.set({ "n", "v" }, "<leader>ct", function()
        ask("/Tests")
      end, {
        desc = "Generate test cases",
      })

      -- Docs
      vim.keymap.set({ "n", "v" }, "<leader>cD", function()
        ask("/Docs")
      end, {
        desc = "Generate documentation comments",
      })

      -- Optimize
      vim.keymap.set({ "n", "v" }, "<leader>co", function()
        ask("/Optimize")
      end, {
        desc = "Suggest performance improvements",
      })

      -- Commit message
      vim.keymap.set("n", "<leader>cC", function()
        ask([[
      #gitdiff:staged
      /Commit
      ]])
      end, {
        desc = "Generate commit message from staged diff",
      })
      
      -- =========================
      -- 💾 SESSION MEMORY
      -- =========================
      
      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          chat.save("last")
        end,
      })
      
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          pcall(chat.load, "last")
        end,
      })
      
      vim.keymap.set("n", "<leader>cS", function()
        chat.save(vim.fn.input("Save session: "))
      end, {
        desc = "Save chat session",
      })
      
      vim.keymap.set("n", "<leader>cL", function()
        chat.load(vim.fn.input("Load session: "))
      end, {
        desc = "Load chat session",
      })
      
      -- =========================
      -- UI
      -- =========================
      
      vim.keymap.set("n", "<leader>cc", chat.toggle, {
        desc = "Toggle Copilot chat window",
      })

      vim.keymap.set("n", "<leader>cM", "<cmd>CopilotChatModels<CR>", {
        desc = "Pick AI model",
      })

      vim.keymap.set("n", "<leader>cx", "<cmd>CopilotChatReset<CR>", {
        desc = "Reset chat history",
      })

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
        end,
      })
    end,
  },
}
