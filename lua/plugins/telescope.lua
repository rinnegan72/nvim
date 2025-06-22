-- ~/.config/nvim/lua/plugins/telescope.lua
-- Telescope fuzzy finder configuration

return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- Add a keymap to browse plugin files
      {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({
            cwd = require("lazy.core.config").options.root,
          })
        end,
        desc = "Find Plugin File",
      },
    },
    -- Change some options
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },
}
