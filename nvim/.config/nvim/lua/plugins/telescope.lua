return {
    {
        "nvim-telescope/telescope.nvim",
        branch = "master",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        cmd = "Telescope",
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<cr>",                desc = "Find files" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>",                 desc = "Live grep" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>",                   desc = "Buffers" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>",                 desc = "Help tags" },
            { "<leader>fr", "<cmd>Telescope oldfiles<cr>",                  desc = "Recent files" },
            { "<leader>fd", "<cmd>Telescope diagnostics<cr>",               desc = "Diagnostics" },
            { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>",      desc = "Document symbols" },
            { "<leader>fw", "<cmd>Telescope lsp_workspace_symbols<cr>",     desc = "Workspace symbols" },
            { "<leader>fc", "<cmd>Telescope grep_string<cr>",               desc = "Grep word under cursor" },
            { "<leader>/",  "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Fuzzy find in buffer" },
        },
        config = function()
            local telescope = require("telescope")
            telescope.setup({
                defaults = {
                    file_ignore_patterns = {
                        "node_modules", ".git/", "target/", "build/",
                        "%.pb%.go$", "%.pb%.gw%.go$", "%.pb%.validate%.go$",
                        "%.swagger%.json$",
                        "/gen/", "/generated/", "/proto/", "/pb/", "/tests/",
                        "internal/api/clients/",
                    },
                    path_display = { "smart" },
                },
                pickers = {
                    find_files = { hidden = true },
                    live_grep = { additional_args = { "--hidden" } },
                    buffers = { theme = "dropdown", previewer = false, sort_mru = true },
                },
            })
            telescope.load_extension("fzf")
        end,
    },
}
