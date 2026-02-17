return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	lazy = false,
	config = function()
		vim.opt.termguicolors = true
		vim.o.background = "dark"

		require("catppuccin").setup({
			flavour = "macchiato", -- of "mocha" (nog donkerder)
			transparent_background = false,
			integrations = {
				treesitter = true,
				native_lsp = {
					enabled = true,
					underlines = {
						errors = { "underline" },
						hints = { "underline" },
						warnings = { "underline" },
						information = { "underline" },
					},
				},
				telescope = true,
				neo_tree = true,
				which_key = true,
			},
		})

		vim.cmd.colorscheme("catppuccin")
	end,
}
