-- ~/.config/nvim/lua/plugins/treesitter.lua
-- Treesitter syntax highlighting configuration

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Extend the default ensure_installed list
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      })
    end,
  },
}
