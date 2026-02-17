local M = {}
require("mini.surround").setup({
	custom_surroundings = {
		p = {
			output = { left = "Promise<", right = ">" },
		},
	},
})
return M
