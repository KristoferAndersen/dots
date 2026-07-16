return {
    -- Formatting
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "ruff_format" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                json = { "prettier" },
                markdown = { "prettier" },
                go = { "gofmt" },
                sh = { "shfmt" },
                bash = { "shfmt" },
            },
            format_on_save = function(bufnr)
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                end
                return { timeout_ms = 3000, lsp_format = "fallback" }
            end,
        },
        init = function()
            vim.api.nvim_create_user_command("FormatDisable", function(args)
                if args.bang then
                    vim.b.disable_autoformat = true
                else
                    vim.g.disable_autoformat = true
                end
            end, { bang = true, desc = "Disable autoformat-on-save (! = buffer only)" })
            vim.api.nvim_create_user_command("FormatEnable", function()
                vim.b.disable_autoformat = false
                vim.g.disable_autoformat = false
            end, { desc = "Re-enable autoformat-on-save" })
        end,
    },

    -- Linting
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")
            lint.linters_by_ft = {
                python = { "ruff" },
                markdown = { "markdownlint" },
            }
            vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },
}
