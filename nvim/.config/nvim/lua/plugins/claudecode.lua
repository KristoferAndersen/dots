return {
    "coder/claudecode.nvim",
    -- Load at startup (not on keypress) so the WebSocket server and lock file
    -- exist before `/ide` is run in the claude tmux pane.
    event = "VeryLazy",
    opts = {
        -- claude runs in a tmux pane next to nvim, never in an embedded terminal
        terminal = { provider = "none" },
        focus_after_send = false,
    },
    keys = {
        { "<leader>a",  nil,                          desc = "Claude Code" },
        { "<leader>as", "<cmd>ClaudeCodeSend<cr>",    mode = "v",           desc = "Send selection to Claude" },
        { "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", ft = { "oil" },       desc = "Add file to Claude" },
        { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",   desc = "Add buffer to Claude" },
        { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude diff" },
        { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Reject Claude diff" },
        { "<leader>aq", "<cmd>ClaudeCodeCloseAllDiffs<cr>", desc = "Close pending Claude diffs" },
    },
}
