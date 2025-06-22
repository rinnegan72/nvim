-- ~/.config/nvim/lua/plugins/ui.lua
-- UI and interface plugins

return {
  -- Terminal integration
  { "akinsho/toggleterm.nvim", version = "*", config = true },

  -- Trouble diagnostics (disabled in example)
  { "folke/trouble.nvim", enabled = false },
  -- Alternative trouble config (if you want to enable it instead)
  -- {
  --   "folke/trouble.nvim",
  --   opts = { use_diagnostic_signs = true },
  -- },
}
