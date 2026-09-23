return {
  -- Active theme
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function(_, opts)
      require("kanagawa").setup(opts)
      vim.cmd.colorscheme("kanagawa")
    end,
  },

  -- Alternates: lazy-loaded on demand when picked via <leader>fp / :colorscheme
  { "catppuccin/nvim", name = "catppuccin", lazy = true },
  { "rose-pine/neovim", name = "rose-pine", lazy = true },
  { "folke/tokyonight.nvim", lazy = true },
}
