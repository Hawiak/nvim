local M = {}

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ===== BASICS =====

map("n", "H", "gg0", { desc = "Top of file" })
map("n", "L", "G$")
map("n", "U", "50k")
map("n", "D", "50j")

map("n", "go", "o<Esc>", { desc = "Open line below" })
map("n", "gO", "O<Esc>", { desc = "Open line above" })

map("n", "cc", 'ggVG"+y', { desc = "Copy whole file" })
map("n", "ca", "ggVG", { desc = "Select whole file" })

map("v", "P", '"_dP', { desc = "Paste without overwriting yank" })

-- ===== CLIPBOARD =====

map("n", "<leader>p", function()
	vim.cmd('normal! "+p')
end, { desc = "Paste clipboard" })

-- ===== DIAGNOSTICS =====

map("n", "<leader>d", function()
	vim.diagnostic.setloclist()
	vim.cmd("lopen")
end, { desc = "Diagnostics list" })

-- ===== LSP =====

map("n", "<C-I>", function()
	vim.lsp.buf.code_action({
		apply = true,
		context = { only = { "source.organizeImports" } },
	})
end, { desc = "Organize imports" })

-- ===== TROUBLE =====

map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>")
map("n", "<leader>xw", "<cmd>Trouble diagnostics toggle workspace=true<cr>")
map("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>")

-- ===== BUFFER NAV (barbar) =====

map("n", "<leader>,", "<Cmd>BufferPrevious<CR>", opts)
map("n", "<leader>.", "<Cmd>BufferNext<CR>", opts)

map("n", "<leader><", "<Cmd>BufferMovePrevious<CR>", opts)
map("n", "<leader>>", "<Cmd>BufferMoveNext<CR>", opts)

for i = 1, 9 do
	map("n", "<leader>" .. i, "<Cmd>BufferGoto " .. i .. "<CR>", opts)
end

map("n", "<leader>0", "<Cmd>BufferLast<CR>", opts)

map("n", "<leader>bp", "<Cmd>BufferPin<CR>", opts)
map("n", "<leader>bc", "<Cmd>BufferClose<CR>", opts)

map("n", "<leader>bb", "<Cmd>BufferPick<CR>", opts)
map("n", "<leader>bD", "<Cmd>BufferPickDelete<CR>", opts)

-- ===== TELESCOPE =====

map("n", "gxd", function()
	require("telescope.builtin").lsp_definitions({
		jump_type = "vsplit",
	})
end, { desc = "Goto definition (vsplit)" })

return M
