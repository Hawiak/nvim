local map = vim.keymap.set

map("n", "H", "gg0", { desc = "Top of file, column 0" })

vim.keymap.set("n", "<leader>p", function()
	vim.cmd('normal! "+p')
end, { silent = true })

vim.keymap.set("n", "<leader>A", "G$", { desc = "Bottom of file, end of line" })
vim.keymap.set("n", "<leader>d", function()
	vim.diagnostic.setloclist()
	vim.cmd("lopen")
end, { desc = "Open [D]iagnostics" })

vim.keymap.set("n", "<C-i>", function()
	vim.lsp.buf.code_action({
		apply = true,
		context = {
			only = { "source.organizeImports" },
		},
	})
end, { desc = "LSP: Organize imports" })
vim.keymap.set("n", "go", "o<Esc>", { desc = "Open line below (no insert)" })
vim.keymap.set("n", "gO", "O<Esc>", { desc = "Open line above (no insert)" })
