-- LSP keymaps die worden ingesteld wanneer LSP attach
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		-- Navigation
		map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
		map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
		map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
		map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

		-- Symbols
		map("go", require("telescope.builtin").lsp_document_symbols, "[O]pen Document Symbols")
		map("gw", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open [W]orkspace Symbols")

		-- Actions
		map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
		map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
		map("K", vim.lsp.buf.hover, "Hover Documentation")

		-- Document highlighting
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client.supports_method("textDocument/documentHighlight", { bufnr = event.buf }) then
			local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
				end,
			})
		end

		-- Inlay hints
		if client and client.supports_method("textDocument/inlayHint", { bufnr = event.buf }) then
			map("<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, "[T]oggle Inlay [H]ints")
		end
	end,
})
