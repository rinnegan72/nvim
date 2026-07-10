-- themer: colorscheme follows ~/.config/themer/current (repo: ~/Projects/themer)
local ok, t = pcall(dofile, vim.fn.expand("~/.config/themer/current/nvim.lua"))
t = ok and t or { colorscheme = "catppuccin-frappe", background = "dark" }
vim.o.background = t.background
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      transparent_background = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        treesitter = true,
        notify = false,
        mini = { enabled = true, indentscope_color = "" },
      },
    },
  },
  { "folke/tokyonight.nvim" },
  { "gbprod/nord.nvim" },
  { "navarasu/onedark.nvim" },
  { "ellisonleao/gruvbox.nvim" },
  { "rose-pine/neovim", name = "rose-pine" },
  { "maxmx03/solarized.nvim" },
  { "LazyVim/LazyVim", opts = { colorscheme = t.colorscheme } },
}
