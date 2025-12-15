return {
    "olimorris/codecompanion.nvim",
    opts = {
        adapters = {
            acp = {
                claude_code = function()
                    return require("codecompanion.adapters").extend("claude_code", {
                        env = {
                            CLAUDE_CODE_OAUTH_TOKEN = "$CLAUDE_CODE_OAUTH_TOKEN",
                        },
                    })
                end,
            },
        },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
}
