-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<C-c>", function()
  local commit_hash = vim.fn.system("git log -1 --format=%h --abbrev=7")
  commit_hash = commit_hash:gsub("%s+", "") -- Remove any trailing whitespace
  vim.fn.setreg("+", commit_hash) -- Copy to the system clipboard
  vim.notify("Copied commit hash: " .. commit_hash, vim.log.levels.INFO)
end, { desc = "Copy abbreviated commit hash" })
