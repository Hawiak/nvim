return {
	"goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },

	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		local project = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

		-- ⭐ FIGLET HEADER
		local handle = io.popen("figlet -f slant " .. project)

		local header = {}

		if handle then
			local result = handle:read("*a")
			handle:close()

			if result and result ~= "" then
				header = vim.split(result, "\n")
			end
		end

		-- fallback als figlet faalt
		if #header == 0 then
			header = {
				"",
				"███ " .. project .. " ███",
				"",
			}
		end

		dashboard.section.header.val = header
		dashboard.section.header.opts.position = "center"
		dashboard.section.header.opts.hl = "Type"

		-- ⭐ BUTTONS
		dashboard.section.buttons.val = {
			dashboard.button("f", "Find files", ":Telescope find_files<CR>"),
			dashboard.button("r", "Recent files", ":Telescope oldfiles<CR>"),
			dashboard.button("q", "Quit", ":qa<CR>"),
		}

		alpha.setup(dashboard.config)

		-- ⭐ KEY FIX voor `nvim .`
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				local argc = vim.fn.argc()
				local argv0 = vim.fn.argv(0)

				if argc == 1 and vim.fn.isdirectory(argv0) == 1 then
					vim.cmd("bd 1")
					vim.schedule(function()
						vim.cmd("Alpha")
					end)
				end
			end,
		})
	end,
}
