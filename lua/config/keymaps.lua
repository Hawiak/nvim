local map = vim.keymap.set

map("n", "H", "gg0", { desc = "Top of file, column 0" })

vim.keymap.set("n", "<leader>p", function()
	vim.cmd('normal! "+p')
end, { silent = true })

vim.keymap.set("n", "<leader>l", "G$", { desc = "Bottom of file, end of line" })
