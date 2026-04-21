return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			open_mapping = [[<C-\>]],
			direction = "float",
			float_opts = { border = "curved" },
		},
		keys = {
			{ "<leader>tt", "<Cmd>ToggleTerm direction=float<CR>", desc = "Terminal float" },
			{ "<leader>th", "<Cmd>ToggleTerm direction=horizontal<CR>", desc = "Terminal horizontal" },
			{ "<leader>tv", "<Cmd>ToggleTerm direction=vertical<CR>", desc = "Terminal vertical" },
		},
	},
}
