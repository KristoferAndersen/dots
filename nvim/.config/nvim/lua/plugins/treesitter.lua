return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		dependencies = { "williamboman/mason.nvim" },
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-treesitter").setup()
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					pcall(vim.treesitter.start)
				end,
			})
			local ensure = {
				"bash",
				"css",
				"go",
				"gomod",
				"gosum",
				"html",
				"java",
				"javascript",
				"json",
				"jsdoc",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"python",
				"regex",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			}
			local function install_missing()
				local installed = require("nvim-treesitter.config").get_installed()
				local to_install = vim.tbl_filter(function(lang)
					return not vim.tbl_contains(installed, lang)
				end, ensure)
				if #to_install > 0 then
					require("nvim-treesitter.install").install(to_install)
				end
			end

			-- Parsers compile via the tree-sitter CLI, which mason provides.
			-- Pinned: >= 0.26 needs glibc 2.39; the Debian 12 devcontainer has 2.36.
			local cli_version = "v0.25.10"
			require("mason")
			local registry = require("mason-registry")
			registry.refresh(function()
				local pkg = registry.get_package("tree-sitter-cli")
				if pkg:get_installed_version() == cli_version then
					install_missing()
					return
				end
				pkg:once("install:success", function()
					vim.schedule(install_missing)
				end)
				pkg:once("install:failed", function()
					vim.schedule(function()
						vim.notify("mason: tree-sitter-cli install failed; run :TSUpdate after fixing", vim.log.levels.WARN)
					end)
				end)
				pkg:install({ version = cli_version })
			end)
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			max_lines = 3,
			multiline_threshold = 1,
		},
		keys = {
			{
				"[x",
				function()
					require("treesitter-context").go_to_context(vim.v.count1)
				end,
				desc = "Jump to context",
			},
		},
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = { lookahead = true },
				move = { set_jumps = true },
			})

			local ts_select = require("nvim-treesitter-textobjects.select")
			local selects = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
			}
			for lhs, obj in pairs(selects) do
				vim.keymap.set({ "x", "o" }, lhs, function()
					ts_select.select_textobject(obj, "textobjects")
				end, { desc = "Select " .. obj })
			end

			local ts_move = require("nvim-treesitter-textobjects.move")
			local moves = {
				goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
				goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
				goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
				goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
			}
			for fn, maps in pairs(moves) do
				for lhs, obj in pairs(maps) do
					vim.keymap.set({ "n", "x", "o" }, lhs, function()
						ts_move[fn](obj, "textobjects")
					end, { desc = obj })
				end
			end
		end,
	},
}
