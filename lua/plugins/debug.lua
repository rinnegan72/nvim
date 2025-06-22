-- ~/.config/nvim/lua/plugins/debug.lua
-- Debug Adapter Protocol (DAP) configuration

return {
  -- DAP UI
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio", -- Required dependency
    },
    config = function()
      local dapui = require("dapui")
      dapui.setup({
        -- Keep UI open after debug session ends
        close_on_end = false,
        controls = {
          enabled = true,
          element = "repl",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 10,
          },
        },
      })

      -- Remove auto-close listeners
      local dap = require("dap")
      dap.listeners.after.event_terminated["dapui_config"] = nil
      dap.listeners.after.event_exited["dapui_config"] = nil

      -- Auto-open UI when debugging starts
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
    end,
  },

  -- Virtual text for debugging
  {
    "theHamsta/nvim-dap-virtual-text",
    config = function()
      require("nvim-dap-virtual-text").setup()
    end,
  },

  -- Telescope integration for DAP
  {
    "nvim-telescope/telescope-dap.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      -- Safely load the extension
      local status_ok, telescope = pcall(require, "telescope")
      if status_ok then
        telescope.load_extension("dap")
      end
    end,
  },

  -- Python debugging support
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      -- Attempt to find python path
      local python_path = vim.fn.exepath("python3") or vim.fn.exepath("python") or "/usr/bin/python3"
      require("dap-python").setup(python_path)
    end,
  },
}
