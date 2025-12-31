local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
local result = handle:read("*a")
handle:close()

local is_dark = result:match("Dark") ~= nil

-- Decide flavour and background based on appearance
local flavour = is_dark and "macchiato" or "latte"
return {

	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	lazy = false,
	config = function()
		vim.opt.termguicolors = true

		require("catppuccin").setup({
			flavour = flavour,
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
