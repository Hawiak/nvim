return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"haydenmeade/neotest-jest",
	},
	opts = function()
		return {
			adapters = {
				require("neotest-jest")({
					jestCommand = "npm test --",
					jestConfigFile = "jest.config.ts",
					env = { CI = true },
					cwd = function()
						return vim.fn.getcwd()
					end,
				}),
			},
		}
	end,
	keys = {
		{
			"<leader>tt",
			function()
				require("neotest").run.run()
			end,
			desc = "Run nearest test",
		},
		{
			"<leader>tf",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "Run test file",
		},
		{
			"<leader>to",
			function()
				require("neotest").output.open({ enter = true })
			end,
			desc = "Test output",
		},
		{
			"<leader>ts",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "Test summary",
		},
	},
}
