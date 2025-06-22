-- ~/.config/nvim/lua/plugins/rust.lua
-- Rust development tools and configuration

return {
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    ft = { "rust" },
    config = function()
      vim.g.rustaceanvim = {
        -- ======================
        -- 1. LSP Configuration (Optimized)
        -- ======================
        server = {
          standalone = true, -- Blocks lspconfig completely
          cmd = { "rustup", "run", "stable", "rust-analyzer" }, -- Explicit rustup binary
          settings = {
            ["rust-analyzer"] = {
              -- Faster compilation checks (disable if too slow)
              checkOnSave = {
                command = "clippy", -- Or set to "check" for faster runs
                extraArgs = {},
              },
              -- Optimized inlay hints (enable only what you need)
              inlayHints = {
                enable = true,
                typeHints = { enable = true },
                parameterHints = { enable = true },
                chainingHints = { enable = false }, -- Disable less useful hints
              },
              -- Faster incremental updates
              files = { watcher = "client" }, -- Uses Neovim's file watcher
            },
          },
          -- Keymaps can be added here (optional)
          on_attach = function(client, bufnr)
            -- Example: Toggle inlay hints with <leader>ih
            vim.keymap.set("n", "<leader>ih", function()
              vim.lsp.inlay_hint.enable(bufnr, not vim.lsp.inlay_hint.is_enabled(bufnr))
            end, { desc = "Toggle inlay hints" })
          end,
        },

        -- ======================
        -- 2. Tools (Optional Add-ons)
        -- ======================
        tools = {
          -- Disable hover actions if unused (slightly faster)
          hover_actions = { auto_focus = false },
          -- Enable only needed tool features
          runnables = { use_telescope = true }, -- Better UI for runnables
        },
      }
    end,
  },
}
