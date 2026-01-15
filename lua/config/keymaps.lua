local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "H", "gg0", { desc = "Top of file, column 0" })

map("n", "<leader>p", '"+p', opts)
map("v", "<leader>p", '"+p', opts)
