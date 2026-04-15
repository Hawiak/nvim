return {
	"kevinhwang91/rnvimr",
	cmd = "RnvimrToggle", -- lazy-load bij eerste gebruik
	keys = {
		{ "<leader>r", "<cmd>RnvimrToggle<CR>", desc = "Ranger" },
	},
	init = function()
		vim.g.rnvimr_enable_ex = 1
		vim.g.rnvimr_enable_picker = 1
		vim.g.rnvimr_draw_border = 1
		vim.g.rnvimr_action = {
			["<CR>"] = "NvimEdit edit",
			["<C-t>"] = "NvimEdit tabedit",
			["<C-x>"] = "NvimEdit split",
			["<C-v>"] = "NvimEdit vsplit",
			["<leader>a"] = "NvimEdit HarpoonAdd false",
		}
	end,
	config = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "rnvimr",
			callback = function(ev)
				vim.keymap.set("t", "<Esc>", "<C-\\><C-n><cmd>RnvimrToggle<CR>", { buffer = ev.buf, silent = true })
				vim.keymap.set(
					"t",
					"<Esc><Esc>",
					"<C-\\><C-n><cmd>RnvimrToggle<CR>",
					{ buffer = ev.buf, silent = true }
				)
				local winid = vim.api.nvim_get_current_win()
				local cfg = vim.api.nvim_win_get_config(winid)
				if cfg.relative ~= "" then
					cfg.border = "rounded"
					vim.api.nvim_win_set_config(winid, cfg)
				end
			end,
		})

		vim.api.nvim_create_user_command("HarpoonAdd", function(opts)
			local list = require("harpoon"):list()
			local item = list.config.create_list_item(list.config, opts.args)
			list:add(item)
			vim.notify("Harpoon: added " .. vim.fn.fnamemodify(opts.args, ":t"))
		end, { nargs = 1 })
	end,
}
