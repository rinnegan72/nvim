return {
  "kawre/leetcode.nvim",
  build = function()
    -- Only run TSUpdate if treesitter is available
    if package.loaded["nvim-treesitter"] then
      vim.cmd("TSUpdate html")
    end
  end,
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-treesitter/nvim-treesitter", -- Explicitly add treesitter as dependency
  },
  opts = {
    -- your configuration here
  },
  -- Optional: lazy load when using Leetcode commands
  cmd = { "Leet", "LeetConsole", "LeetSubmit" },
}
