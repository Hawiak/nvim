return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		build = "make tiktoken",
		opts = {
			context = {
				providers = {
					buffers = true,
					file = true,
					git = true,
					diagnostics = true,
				},
			},
			auto_insert_mode = true,
		},
		keys = {
			{ "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Copilot Chat" },
			{ "<leader>cf", "<cmd>CopilotChatFix<cr>", desc = "Copilot Fix" },
			{ "<leader>cr", "<cmd>CopilotChatRewrite<cr>", desc = "Copilot Rewrite" },
			{ "<leader>ce", "<cmd>CopilotChatExplain<cr>", desc = "Copilot Explain" },
		},
	},
}
