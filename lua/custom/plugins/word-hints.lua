-- lua/custom/plugins/word-hints.lua
return {
	"word-hints",
	dir = vim.fn.stdpath("config") .. "/lua/custom",
	name = "word-hints",
	lazy = false,
	config = function()
		require("custom.word-hints").setup({
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
