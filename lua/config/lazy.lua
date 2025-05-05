local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- Add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- Import/override with your plugins
    { import = "plugins" },

    -- Core tools
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "neovim/nvim-lspconfig" }, -- Added missing LSP configuration

    -- Rust tools
    {
      "mrcjkb/rustaceanvim",
      version = "^6",
      ft = { "rust" },
      config = function()
        vim.g.rustaceanvim = {
          -- ======================
          -- 1. LSP Configuration (Optimized)
          -- ======================
          server = {
            standalone = true, -- Blocks lspconfig completely
            cmd = { "rustup", "run", "stable", "rust-analyzer" }, -- Explicit rustup binary
            settings = {
              ["rust-analyzer"] = {
                -- Faster compilation checks (disable if too slow)
                checkOnSave = {
                  command = "clippy", -- Or set to "check" for faster runs
                  extraArgs = {},
                },
                -- Optimized inlay hints (enable only what you need)
                inlayHints = {
                  enable = true,
                  typeHints = { enable = true },
                  parameterHints = { enable = true },
                  chainingHints = { enable = false }, -- Disable less useful hints
                },
                -- Faster incremental updates
                files = { watcher = "client" }, -- Uses Neovim's file watcher
              },
            },
            -- Keymaps can be added here (optional)
            on_attach = function(client, bufnr)
              -- Example: Toggle inlay hints with <leader>ih
              vim.keymap.set("n", "<leader>ih", function()
                vim.lsp.inlay_hint.enable(bufnr, not vim.lsp.inlay_hint.is_enabled(bufnr))
              end, { desc = "Toggle inlay hints" })
            end,
          },

          -- ======================
          -- 2. Tools (Optional Add-ons)
          -- ======================
          tools = {
            -- Disable hover actions if unused (slightly faster)
            hover_actions = { auto_focus = false },
            -- Enable only needed tool features
            runnables = { use_telescope = true }, -- Better UI for runnables
          },
        }
      end,
    },

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
  },
  -- Keep the rest of your lazy.nvim setup options
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true, notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Keymaps for debugging
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "rust", "python" },
  callback = function()
    local opts = { buffer = true }
    vim.keymap.set("n", "<F5>", function()
      require("dap").continue()
      require("dapui").open() -- Ensure UI opens when starting
    end, opts)
    vim.keymap.set("n", "<F9>", "<cmd>lua require('dap').toggle_breakpoint()<cr>", opts)
    vim.keymap.set("n", "<F10>", "<cmd>lua require('dap').step_over()<cr>", opts)
    vim.keymap.set("n", "<F11>", "<cmd>lua require('dap').step_into()<cr>", opts)
    vim.keymap.set("n", "<F12>", "<cmd>lua require('dap').step_out()<cr>", opts)
    vim.keymap.set("n", "<leader>db", "<cmd>lua require('dapui').toggle()<cr>", opts)
    vim.keymap.set("n", "<leader>dc", "<cmd>lua require('dap').terminate()<cr>", opts)
    vim.keymap.set("n", "<leader>dl", "<cmd>lua require('dap').run_last()<cr>", opts)
    vim.keymap.set("n", "<leader>dr", "<cmd>lua require('dap').repl.toggle()<cr>", opts)
    vim.keymap.set("n", "<leader>dh", "<cmd>lua require('dap.ui.widgets').hover()<cr>", opts)
  end,
})

-- Add a command to show debug help
vim.api.nvim_create_user_command("DebugHelp", function()
  print("Debug Keymaps:")
  print("F5: Start/Continue Debug")
  print("F9: Toggle Breakpoint")
  print("F10: Step Over")
  print("F11: Step Into")
  print("F12: Step Out")
  print("<leader>db: Toggle Debug UI")
  print("<leader>dc: Terminate Debug")
  print("<leader>dl: Run Last")
  print("<leader>dr: Toggle REPL")
  print("<leader>dh: Show Variable Hover")
end, {})

-- Auto-detect Python virtual environments
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    -- Try to find and set the python path from virtualenv
    local venv = os.getenv("VIRTUAL_ENV")
    if venv then
      local python_path = venv .. "/bin/python"
      require("dap-python").setup(python_path)
    end
  end,
})
