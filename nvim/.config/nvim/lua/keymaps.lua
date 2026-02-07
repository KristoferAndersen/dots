local map = vim.keymap.set

map("n", "<leader>o", ":update<CR> :source<CR>", { desc = "Save and source" })
map("n", "<leader>pv", ":Ex<CR>", { desc = "Open file explorer" })

-- Window resize
map("n", "<C-Up>", ":resize +2<CR>", { silent = true })
map("n", "<C-Down>", ":resize -2<CR>", { silent = true })
map("n", "<C-Left>", ":vertical resize -2<CR>", { silent = true })
map("n", "<C-Right>", ":vertical resize +2<CR>", { silent = true })

-- Buffer navigation
map("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer", silent = true })
map("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer", silent = true })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer", silent = true })

-- Move lines in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })

-- Keep cursor centered
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Better paste (don't yank replaced text)
map("x", "<leader>p", '"_dP', { desc = "Paste without yank" })

-- Clear search highlight
map("n", "<Esc>", ":noh<CR>", { silent = true })
