return {
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup({

				hijack_directories = {
					enable = true,
					auto_open = false,
				},
			})

			vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle nvim-tree" })

			local last_tree_focus = 0
			vim.api.nvim_create_autocmd("BufEnter", {
				callback = function()
					vim.cmd("NvimTreeClose")
				end,
			})

			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					local line_count = vim.api.nvim_buf_line_count(0)
					if line_count == 1 then
						local line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
						if line == "" then
							vim.cmd("NvimTreeOpen")
						end
					end
				end,
			})
		end,
	},
}
