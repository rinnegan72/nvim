return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "frappe",
      transparent_background = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        treesitter = true,
        notify = false,
        mini = {
          enabled = true,
          indentscope_color = "",
        },
      },
    },
    config = function(_, opts)
      local ok, catppuccin = pcall(require, "catppuccin")
      if not ok then
        vim.notify("Catppuccin failed to load!", vim.log.levels.ERROR)
        return
      end
      catppuccin.setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
