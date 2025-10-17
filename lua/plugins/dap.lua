-- ~/.config/nvim/lua/plugins/dap.lua
-----------------------------------------------------------
-- Debugging: DAP + UI
-----------------------------------------------------------

return {
  -- Core DAP
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    event = "VeryLazy", -- or BufRead
    config = function()
      local dap = require("dap")

      -- Optional: keymaps for debugging
      local map = vim.keymap.set
      local opts = { noremap = true, silent = true }

      map("n", "<F5>", dap.continue, opts)
      map("n", "<F10>", dap.step_over, opts)
      map("n", "<F11>", dap.step_into, opts)
      map("n", "<F12>", dap.step_out, opts)
      map("n", "<leader>b", dap.toggle_breakpoint, opts)
      map("n", "<leader>B", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, opts)
    end,
  },

  -- DAP UI
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()

      -- Open/close UI automatically
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },

  -- Python adapter
  {
    "mfussenegger/nvim-dap-python",
    lazy = true,
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local dap_python = require("dap-python")
      dap_python.setup("python")  -- or path to python executable
    end,
  },

  -- JavaScript / TypeScript adapter via vscode-js-debug (optional)
  {
    "mxsdev/nvim-dap-vscode-js",
    lazy = true,
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-vscode-js").setup({
        adapters = { "pwa-node", "pwa-chrome" }, -- node, chrome, edge, firefox
      })

      for _, language in ipairs({ "typescript", "javascript" }) do
        require("dap").configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
        }
      end
    end,
  },
}
