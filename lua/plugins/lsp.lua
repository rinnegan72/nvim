-- ~/.config/nvim/lua/plugins/lsp.lua
-- LSP and language server configuration

return {
  -- Core LSP tools with additional packages
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
  },
  { "williamboman/mason-lspconfig.nvim" },

  -- LSP configuration with Python support
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- Pyright will be automatically installed with mason and loaded with lspconfig
        pyright = {},
        -- Disable rust_analyzer (handled by rustaceanvim)
        rust_analyzer = false,
      },
    },
  },
}
