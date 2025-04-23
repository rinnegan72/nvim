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
    { "williamboman/mason.nvim" },

    -- Add rustaceanvim for Rust development
    {
      "mrcjkb/rustaceanvim",
      version = "^6", -- Recommended
      lazy = false, -- This plugin is already lazy
    },

    -- Add Python venv selection
    {
      "linux-cultist/venv-selector.nvim",
      dependencies = {
        "neovim/nvim-lspconfig",
        "nvim-telescope/telescope.nvim",
        "mfussenegger/nvim-dap-python",
      },
      opts = {
        -- Configuration options for venv-selector.nvim
        name = {
          "venv",
          ".venv",
          "env",
          ".env",
        },
        auto_refresh = true, -- Automatically refresh the list of virtual environments
      },
      keys = {
        -- Keymap to open VenvSelector to pick a venv
        { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
        -- Keymap to retrieve the venv from cache (previously used for the same project directory)
        { "<leader>vc", "<cmd>VenvSelectCached<cr>", desc = "Select Cached VirtualEnv" },
      },
      event = "VeryLazy", -- Load the plugin lazily
    },

    -- Configure Pyright LSP server
    {
      "neovim/nvim-lspconfig",
      opts = {
        servers = {
          pyright = {
            -- Pyright configuration options
            settings = {
              python = {
                analysis = {
                  autoSearchPaths = true,
                  useLibraryCodeForTypes = true,
                  diagnosticMode = "workspace",
                },
              },
            },
          },
        },
      },
    },
  },
  defaults = {
    lazy = false, -- Load plugins immediately (set to `true` for lazy-loading)
    version = false, -- Always use the latest version of plugins
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- Check for plugin updates periodically
    notify = false, -- Disable notifications for updates
  },
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

-- Optional: Automatically activate venv-selector when opening Python files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.schedule(function()
      local venv_selector = require("venv-selector")
      if venv_selector then
        venv_selector.retrieve_from_cache()
      end
    end)
  end,
})
