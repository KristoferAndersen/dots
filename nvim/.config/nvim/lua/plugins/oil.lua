return {
	{
		"stevearc/oil.nvim",
		dependencies = { "echasnovski/mini.icons" },
		cmd = "Oil",
		opts = {
			view_options = {
				show_hidden = true,
			},
		},
		keys = {
			{ "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
		},
	},
}
