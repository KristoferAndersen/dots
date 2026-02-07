return {
	-- nvim-lspconfig provides default cmd/filetypes/root_markers for servers
	-- We don't call require('lspconfig') — just installing it makes
	-- vim.lsp.config/enable pick up its server definitions automatically
	{
		"neovim/nvim-lspconfig",
		lazy = false,
	},

	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
			"saghen/blink.cmp",
			"b0o/SchemaStore.nvim",
		},
		lazy = false,
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"pyright",
					"ruff",
					"jdtls",
					"jsonls",
					"bashls",
					"ts_ls",
					"angularls",
					"marksman",
					"helm_ls",
					"gopls",
					"yamlls",
					"cssls",
				},
				automatic_installation = true,
			})

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
				gopls = {},
				cssls = {},
				yamlls = {
					settings = {
						yaml = {
							schemaStore = { enable = false, url = "" },
							schemas = require("schemastore").yaml.schemas(),
						},
					},
				},
			}

			for server, config in pairs(servers) do
				config.capabilities = capabilities
				vim.lsp.config(server, config)
			end

			vim.lsp.enable(vim.tbl_keys(servers))
		end,
	},
}
