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
            { "<leader>fw", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace symbols" },
            { "<leader>fc", "<cmd>Telescope grep_string<cr>",               desc = "Grep word under cursor" },
            { "<leader>/",  "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Fuzzy find in buffer" },
            { "<leader>fp", "<cmd>Telescope colorscheme enable_preview=true<cr>", desc = "Colorschemes (live preview)" },
        },
        config = function()
            local telescope = require("telescope")

            -- Exclusions live in fd/rg (native, gitignore-style globs) instead
            -- of file_ignore_patterns, which runs Lua matches on every result.
            local excludes = {
                ".git",
                ".worktrees",
                "node_modules",
                "target",
                "build",
                "gen",
                "generated",
                "pb",
                "tests",
                "mock",
                "mocks",
                "internal/api/clients",
                "*.pb.go",
                "*.pb.gw.go",
                "*.pb.validate.go",
                "*.swagger.json",
                "*_mock.go",
            }

            local fd = vim.fn.executable("fd") == 1 and "fd" or "fdfind"
            local find_command = { fd, "--type", "f", "--hidden" }
            local vimgrep_arguments = {
                "rg", "--color=never", "--no-heading", "--with-filename",
                "--line-number", "--column", "--smart-case", "--hidden",
            }
            for _, pattern in ipairs(excludes) do
                vim.list_extend(find_command, { "--exclude", pattern })
                vim.list_extend(vimgrep_arguments, { "--glob", "!" .. pattern })
            end

            telescope.setup({
                defaults = {
                    vimgrep_arguments = vimgrep_arguments,
                    path_display = { "filename_first" },
                },
                pickers = {
                    find_files = { find_command = find_command },
                    buffers = { theme = "dropdown", previewer = false, sort_mru = true },
                },
            })
            telescope.load_extension("fzf")
        end,
    },
}
