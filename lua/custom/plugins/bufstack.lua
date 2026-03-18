return {
	"BibekBhusal0/bufstack.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim", -- optional: required for menu
		"nvim-lua/plenary.nvim", -- optional: required to shorten path
		"nvim-telescope/telescope.nvim", -- optional: required for telescope picker
		"nvim-tree/nvim-web-devicons", -- optional: required for icon in telescope picker
		"stevearc/resession.nvim", -- optional: for session persistence
	},
	opts = {
		max_tracked = 16,
		shorten_path = true,
	},
}
