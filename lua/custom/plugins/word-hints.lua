-- lua/custom/plugins/word-hints.lua
return {
	"word-hints",
	dir = vim.fn.stdpath("config") .. "/lua/custom",
	name = "word-hints",
	lazy = false,
	config = function()
		vim.api.nvim_set_hl(0, "WordHintFwd", { fg = "#3a3a3a", ctermfg = 238 })
		vim.api.nvim_set_hl(0, "WordHintBwd", { fg = "#2a2a2a", ctermfg = 237 })
		require("custom.word-hints").setup({
			context_lines = 2,
			mode = "all",
			max_words = 20,
			debounce_ms = 50,
			forward_hl = "Comment",
			forward_fmt = "%d",
			backward_fmt = "%d",
		})
		vim.keymap.set("n", "<leader>wh", "<cmd>WordHintsToggle<cr>", { desc = "Toggle word hints" })
	end,
}
