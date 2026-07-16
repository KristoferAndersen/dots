return {
  {
    "saghen/blink.cmp",
    version = "*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      keymap = {
        preset = "default",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      completion = {
        documentation = { auto_show = true },
        list = {
          selection = { preselect = true, auto_insert = false },
        },
      },
    },
  },

  -- Auto-close brackets and quotes
  {
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    opts = {},
    keys = {
      {
        "<CR>",
        function()
          local pair_chars = { ["("] = ")", ["["] = "]", ["{"] = "}" }
          local line = vim.api.nvim_get_current_line()
          local col = vim.api.nvim_win_get_cursor(0)[2]
          local before = line:sub(col, col)
          local after = line:sub(col + 1, col + 1)
          if pair_chars[before] == after then
            return "<CR><Esc>O"
          end
          return "<CR>"
        end,
        mode = "i",
        expr = true,
        replace_keycodes = true,
      },
    },
  },
}
