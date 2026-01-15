return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			-- UI / helpers
			dapui.setup()
			require("dap-go").setup()
			require("nvim-dap-virtual-text").setup()
			---------------------------------------------------------------------
			-- Keymaps
			---------------------------------------------------------------------
			vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
			vim.keymap.set("n", "<leader>gb", dap.run_to_cursor)
			vim.keymap.set("n", "<leader>?", function()
				dapui.eval(nil, { enter = true })
			end)
			vim.keymap.set("n", "<F1>", dap.continue)
			vim.keymap.set("n", "<F2>", dap.step_into)
			vim.keymap.set("n", "<F3>", dap.step_over)
			vim.keymap.set("n", "<F4>", dap.step_out)
			vim.keymap.set("n", "<F12>", dap.restart)
			---------------------------------------------------------------------
			-- JS / TS DEBUG ADAPTER
			---------------------------------------------------------------------
			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "node",
					args = {
						vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
						"${port}",
					},
				},
			}
			---------------------------------------------------------------------
			-- TypeScript / JavaScript configs
			---------------------------------------------------------------------
			for _, language in ipairs({ "typescript", "javascript" }) do
				dap.configurations[language] = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Debug Jest Tests",
						runtimeExecutable = "node",
						runtimeArgs = {
							"./node_modules/jest/bin/jest.js",
							"--runInBand",
							"--no-coverage",
							"--no-cache",
							"--watchAll=false",
							"--detectOpenHandles",
							"--forceExit",
						},
						rootPath = "${workspaceFolder}",
						cwd = "${workspaceFolder}",
						console = "integratedTerminal",
						internalConsoleOptions = "neverOpen",
						sourceMaps = true,
						sourceMapPathOverrides = {
							["<rootDir>/*"] = "${workspaceFolder}/*",
							["webpack:///./*"] = "${workspaceFolder}/*",
							["./*"] = "${workspaceFolder}/*",
						},
						resolveSourceMapLocations = {
							"${workspaceFolder}/**",
							"!**/node_modules/**",
							"!**/node_modules/ts-node/**",
							"!**/node_modules/typescript/**",
						},
						skipFiles = {
							"<node_internals>/**",
							"**/node_modules/**",
						},
						-- Zet dit aan als het nog steeds niet werkt om te debuggen
						-- trace = true,
					},
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach to Jest",
						processId = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
						sourceMaps = true,
						sourceMapPathOverrides = {
							["<rootDir>/*"] = "${workspaceFolder}/*",
							["webpack:///./*"] = "${workspaceFolder}/*",
							["./*"] = "${workspaceFolder}/*",
						},
						resolveSourceMapLocations = {
							"${workspaceFolder}/**",
							"!**/node_modules/**",
						},
						skipFiles = {
							"<node_internals>/**",
							"**/node_modules/**",
						},
					},
				}
			end
			---------------------------------------------------------------------
			-- DAP UI lifecycle
			---------------------------------------------------------------------
			dap.listeners.after.event_initialized.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,
	},
}
