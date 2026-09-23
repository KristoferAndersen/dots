return {
    -- nvim-lspconfig provides default cmd/filetypes/root_markers for servers
    -- We don't call require('lspconfig') — just installing it makes
    -- vim.lsp.config/enable pick up its server definitions automatically
    {
        "neovim/nvim-lspconfig",
        lazy = true,
    },

    {
        "williamboman/mason.nvim",
        lazy = true,
        config = function()
            require("mason").setup()
        end,
    },

    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        config = function()
            require("fidget").setup()
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
            "saghen/blink.cmp",
            "b0o/SchemaStore.nvim",
            "j-hui/fidget.nvim",
        },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            vim.diagnostic.config({
                virtual_text = true,
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local map = function(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, desc = desc })
                    end
                    local tb = require("telescope.builtin")
                    map("n", "gd", tb.lsp_definitions, "Go to definition")
                    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
                    map("n", "gr", tb.lsp_references, "Go to references")
                    map("n", "gi", tb.lsp_implementations, "Go to implementation")
                    map("n", "gy", tb.lsp_type_definitions, "Go to type definition")
                    map("n", "gs", tb.lsp_document_symbols, "Document symbols")
                    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
                    map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
                    map("n", "<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
                end,
            })

            local capabilities = require("blink.cmp").get_lsp_capabilities()

            -- Kill the shared gopls daemon (-remote=auto) and restart the
            -- client. Use after branch switches or when gopls state goes
            -- stale (the daemon caches build flags from the first client).
            vim.api.nvim_create_user_command("GoplsRestart", function()
                vim.fn.jobstart({ "pkill", "-f", "gopls" })
                vim.defer_fn(function()
                    vim.cmd("LspRestart gopls")
                end, 200)
            end, { desc = "Kill gopls daemon and restart" })

            -- Editor module resolution for gopls:
            --   default "readonly" -> resolve from the module cache and ignore
            --     vendor/ (so vendor drift never breaks gopls), but never let
            --     gopls write go.mod/go.sum. Run `go mod tidy` yourself.
            --   air-gapped container (private deps only in vendor/): export
            --     GOPLS_MOD=vendor so gopls can still resolve private imports.
            --   GOPLS_MOD=mod re-enables auto-editing of go.mod if you want it.
            -- Real builds/CI use vendor regardless (go defaults to -mod=vendor).
            local go_mod = vim.env.GOPLS_MOD or "readonly"

            local go_dir_filters = {
                "-**/.worktrees",
                "-internal/api/clients",
                "-internal/tests/helpers",
                "-**/gen",
                "-**/generated",
                "-**/proto",
                "-**/pb",
                "-**/tests",
            }
            -- Outside vendor mode gopls resolves from the module cache, so
            -- vendor/ is dead weight for scanning/watching — skip it.
            if go_mod ~= "vendor" then
                table.insert(go_dir_filters, "-**/vendor")
            end

            local servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            workspace = { checkThirdParty = false },
                            telemetry = { enable = false },
                            hint = { enable = true },
                        },
                    },
                },
                pyright = {},
                ruff = {},
                jdtls = {},
                jsonls = {
                    settings = {
                        json = {
                            schemas = require("schemastore").json.schemas(),
                            validate = { enable = true },
                        },
                    },
                },
                bashls = {},
                ts_ls = {},
                angularls = {},
                marksman = {},
                helm_ls = {},
                gopls = {
                    -- timeout=0: the auto-started daemon stays alive after the
                    -- last editor detaches, keeping the metadata graph warm.
                    cmd = { "gopls", "-remote=auto", "-remote.listen.timeout=0" },
                    settings = {
                        gopls = {
                            directoryFilters = go_dir_filters,
                            buildFlags = { "-tags=manual", "-mod=" .. go_mod },
                            symbolMatcher = "fastFuzzy",
                        },
                    },
                },
                cssls = {},
                yamlls = {
                    settings = {
                        yaml = {
                            schemaStore = { enable = false, url = "" },
                            schemas = require("schemastore").yaml.schemas(),
                        },
                    },
                },
                snip_ls = {
                    cmd = { "snip-ls", "-diagnostics" },
                },
            }

            local mason_ensure = vim.tbl_filter(function(name)
                return name ~= "snip_ls"
            end, vim.tbl_keys(servers))
            require("mason-lspconfig").setup({
                ensure_installed = mason_ensure,
                automatic_enable = false,
            })

            for server, config in pairs(servers) do
                config.capabilities = capabilities
                vim.lsp.config(server, config)
            end

            vim.lsp.enable(vim.tbl_keys(servers))
        end,
    },
}
