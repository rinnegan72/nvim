return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html", -- Only needed if you have nvim-treesitter
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    -- Your configuration options go here
    -- Example configuration (check the plugin docs for available options):
    -- lang = "python", -- Default language
  },
  -- Optional: Only load when you want to use it
  -- cmd = "Leet",
}
