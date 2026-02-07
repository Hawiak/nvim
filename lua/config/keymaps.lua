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

-- Custom keymaps for navigation and copy+pasting like a real developer
vim.keymap.set("n", "L", "G$")
vim.keymap.set("n", "U", "50k")

vim.keymap.set("n", "D", "50j")

vim.keymap.set("n", "cc", 'ggVG"+y')

vim.keymap.set("n", "ca", 'ggVG"')

vim.keymap.set("v", "P", '"_dP', { desc = "Paste without overwriting yank" })

-- Trouble keymaps
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>")
vim.keymap.set("n", "<leader>xw", "<cmd>Trouble diagnostics toggle workspace=true<cr>")
vim.keymap.set("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>")

-- Move to previous/next
map("n", "<leader>,", "<Cmd>BufferPrevious<CR>", opts)
map("n", "<leader>.", "<Cmd>BufferNext<CR>", opts)

-- Re-order buffers
map("n", "<leader><", "<Cmd>BufferMovePrevious<CR>", opts)
map("n", "<leader>>", "<Cmd>BufferMoveNext<CR>", opts)

-- Goto buffer by position
map("n", "<leader>1", "<Cmd>BufferGoto 1<CR>", opts)
map("n", "<leader>2", "<Cmd>BufferGoto 2<CR>", opts)
map("n", "<leader>3", "<Cmd>BufferGoto 3<CR>", opts)
map("n", "<leader>4", "<Cmd>BufferGoto 4<CR>", opts)
map("n", "<leader>5", "<Cmd>BufferGoto 5<CR>", opts)
map("n", "<leader>6", "<Cmd>BufferGoto 6<CR>", opts)
map("n", "<leader>7", "<Cmd>BufferGoto 7<CR>", opts)
map("n", "<leader>8", "<Cmd>BufferGoto 8<CR>", opts)
map("n", "<leader>9", "<Cmd>BufferGoto 9<CR>", opts)
map("n", "<leader>0", "<Cmd>BufferLast<CR>", opts)

-- Pin/unpin
map("n", "<leader>bp", "<Cmd>BufferPin<CR>", opts)

-- Close buffer
map("n", "<leader>bc", "<Cmd>BufferClose<CR>", opts)

-- Buffer picking (super handig)
map("n", "<leader>bb", "<Cmd>BufferPick<CR>", opts)
map("n", "<leader>bD", "<Cmd>BufferPickDelete<CR>", opts)

-- Sorting
map("n", "<leader>bs", "<Cmd>BufferOrderByBufferNumber<CR>", opts)
map("n", "<leader>bn", "<Cmd>BufferOrderByName<CR>", opts)
map("n", "<leader>bd", "<Cmd>BufferOrderByDirectory<CR>", opts)
map("n", "<leader>bl", "<Cmd>BufferOrderByLanguage<CR>", opts)
map("n", "<leader>bw", "<Cmd>BufferOrderByWindowNumber<CR>", opts)
