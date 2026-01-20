return {
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup({
				view = {
					number = true,
					relativenumber = true,
				},
				hijack_directories = {
					enable = true,
					auto_open = false,
				},
				filters = {
					git_ignored = false,
				},
			})

			vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle tree" })
			vim.keymap.set("n", "<leader>f", ":NvimTreeFindFile<CR>", { desc = "Reveal current file in tree" })

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
