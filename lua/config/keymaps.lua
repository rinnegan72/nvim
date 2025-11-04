-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<C-c>", function()
  local commit_hash = vim.fn.system("git log -1 --format=%h --abbrev=7")
  commit_hash = commit_hash:gsub("%s+", "") -- Remove any trailing whitespace
  vim.fn.setreg("+", commit_hash) -- Copy to the system clipboard
  vim.notify("Copied commit hash: " .. commit_hash, vim.log.levels.INFO)
end, { desc = "Copy abbreviated commit hash" })

-- Quick branch file opener
vim.keymap.set("n", "<leader>gf", function()
  local branch = vim.fn.input("Branch: ")
  if branch ~= "" then
    local current_file = vim.fn.expand("%")
    local cmd = string.format("git show %s:%s", branch, current_file)
    local content = vim.fn.system(cmd)

    if vim.v.shell_error == 0 then
      vim.cmd("vnew")
      vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(content, "\n"))
      vim.bo.readonly = true
      vim.bo.modifiable = false
      vim.bo.filetype = vim.filetype.match({ buf = 0 }) or vim.bo.filetype -- inherit filetype
      vim.notify("Opened " .. current_file .. " from branch: " .. branch, vim.log.levels.INFO)
    else
      vim.notify("File not found in branch: " .. branch, vim.log.levels.ERROR)
    end
  end
end, { desc = "Open file from branch" })

-- Show file differences between branches
vim.keymap.set("n", "<leader>gD", function()
  local branch = vim.fn.input("Compare current file with branch: ")
  if branch ~= "" then
    local current_file = vim.fn.expand("%")
    vim.cmd(string.format("terminal git diff %s -- %s", branch, current_file))
  end
end, { desc = "Compare file with branch (terminal)" })

require("gitsigns").setup({
  signs = {
    add = { text = "┃" },
    change = { text = "┃" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true,
  },
  auto_attach = true,
  attach_to_untracked = false,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 0,
    ignore_whitespace = false,
    virt_text_priority = 100,
  },
  current_line_blame_formatter = "<abbrev_sha> <author>, <author_time:%Y-%m-%d> - <summary>",
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    border = "single",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  on_attach = function(bufnr)
    local gitsigns = require("gitsigns")

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end, { desc = "Next hunk" })

    map("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end, { desc = "Previous hunk" })

    -- Actions
    map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
    map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })

    map("v", "<leader>hs", function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Stage hunk (visual)" })

    map("v", "<leader>hr", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Reset hunk (visual)" })

    map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage buffer" })
    map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset buffer" })
    map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk" })
    map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Preview hunk inline" })

    map("n", "<leader>hb", function()
      gitsigns.blame_line({ full = true })
    end, { desc = "Blame line" })

    map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff this" })

    map("n", "<leader>hD", function()
      gitsigns.diffthis("~")
    end, { desc = "Diff this ~" })

    -- Branch comparison mappings
    map("n", "<leader>hc", function()
      local branch = vim.fn.input("Compare with branch: ")
      if branch ~= "" then
        gitsigns.diffthis(branch)
      end
    end, { desc = "Compare with branch" })

    map("n", "<leader>hQ", function()
      gitsigns.setqflist("all")
    end, { desc = "All hunks to quickfix" })

    map("n", "<leader>hq", gitsigns.setqflist, { desc = "Hunks to quickfix" })

    -- Toggles
    map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle git blame" })
    map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "Toggle word diff" })
    map("n", "<leader>th", gitsigns.toggle_deleted, { desc = "Toggle deleted hunks" })

    -- Text object
    map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Git hunk" })
  end,
})
