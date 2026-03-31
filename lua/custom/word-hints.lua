-- lua/custom/word-hints.lua
-- Ghost text met w/b jump counts, zoals relative line numbers maar horizontaal.

local M = {}

local ns = vim.api.nvim_create_namespace("word_hints")

local config = {
	enabled = true,
	debounce_ms = 50,
	-- Hoeveel regels boven/onder de cursor hints tonen
	context_lines = 2,
	-- "all" = elk woord, "power" = alleen veelvouden van 5
	mode = "all",
	-- Aparte highlight groups voor vooruit en achteruit
	forward_hl = "Comment",
	backward_hl = "DiagnosticHint",
	forward_fmt = "%d",
	backward_fmt = "%d",
	-- Filetypes/buftypes om over te skippen
	excluded_filetypes = { "neo-tree", "NvimTree", "alpha", "dashboard", "snacks" },
	excluded_buftypes = { "nofile", "terminal", "prompt" },
}

-- ── word boundary detection (w/b semantics, niet W/B) ────────────────────────

local function chartype(c)
	if c:match("[a-zA-Z0-9_]") then
		return "word"
	elseif c:match("%s") then
		return "space"
	else
		return "punct"
	end
end

local function word_starts(lnum)
	local line = vim.api.nvim_buf_get_lines(0, lnum, lnum + 1, false)[1]
	if not line then
		return {}
	end
	local positions = {}
	local prev = "space"
	for i = 1, #line do
		local cur = chartype(line:sub(i, i))
		if cur ~= "space" and (prev == "space" or prev ~= cur) then
			positions[#positions + 1] = i - 1
		end
		prev = cur
	end
	return positions
end

-- ── rendering ────────────────────────────────────────────────────────────────

local timer = nil

local function render()
	local buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

	if not config.enabled then
		return
	end
	if vim.api.nvim_get_mode().mode ~= "n" then
		return
	end

	local ft = vim.bo[buf].filetype
	local bt = vim.bo[buf].buftype

	for _, v in ipairs(config.excluded_filetypes) do
		if ft == v then
			return
		end
	end
	for _, v in ipairs(config.excluded_buftypes) do
		if bt == v then
			return
		end
	end
	if ft == "" then
		return
	end

	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	row = row - 1

	local function place(lnum, wcol, count, hl, fmt)
		local show = config.mode == "all" or (count % 5 == 0)
		if not show then
			return
		end
		vim.api.nvim_buf_set_extmark(buf, ns, lnum, wcol, {
			virt_text = { { fmt:format(count), hl } },
			virt_text_pos = "inline",
			hl_mode = "combine",
			priority = 10,
		})
	end

	-- ── huidige regel: w vooruit, b achteruit ────────────────────────────────
	local starts = word_starts(row)

	local fwd_count = 0
	for _, wc in ipairs(starts) do
		if wc > col then
			fwd_count = fwd_count + 1
			place(row, wc, fwd_count, config.forward_hl, config.forward_fmt)
		end
	end

	local bwd_count = 0
	for i = #starts, 1, -1 do
		local wc = starts[i]
		if wc < col then
			bwd_count = bwd_count + 1
			place(row, wc, bwd_count, config.backward_hl, config.backward_fmt)
		end
	end

	-- ── regels onder: w telt door ─────────────────────────────────────────────
	local total = vim.api.nvim_buf_line_count(buf)
	for lnum = row + 1, math.min(total - 1, row + config.context_lines) do
		for _, wc in ipairs(word_starts(lnum)) do
			fwd_count = fwd_count + 1
			place(lnum, wc, fwd_count, config.forward_hl, config.forward_fmt)
		end
	end

	-- ── regels boven: b telt door ─────────────────────────────────────────────
	for lnum = row - 1, math.max(0, row - config.context_lines), -1 do
		local ls = word_starts(lnum)
		for i = #ls, 1, -1 do
			bwd_count = bwd_count + 1
			place(lnum, ls[i], bwd_count, config.backward_hl, config.backward_fmt)
		end
	end
end

local function schedule_render()
	if timer then
		timer:stop()
		timer:close()
		timer = nil
	end
	if config.debounce_ms == 0 then
		render()
		return
	end
	timer = vim.loop.new_timer()
	timer:start(config.debounce_ms, 0, vim.schedule_wrap(render))
end

-- ── public API ───────────────────────────────────────────────────────────────

function M.toggle()
	config.enabled = not config.enabled
	if not config.enabled then
		vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
	else
		render()
	end
	vim.notify("word-hints " .. (config.enabled and "on" or "off"))
end

function M.setup(opts)
	config = vim.tbl_deep_extend("force", config, opts or {})

	local grp = vim.api.nvim_create_augroup("WordHints", { clear = true })

	vim.api.nvim_create_autocmd(
		{ "CursorMoved", "BufEnter", "WinEnter", "ModeChanged" },
		{ group = grp, callback = schedule_render }
	)
	vim.api.nvim_create_autocmd("BufLeave", {
		group = grp,
		callback = function()
			vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
		end,
	})

	vim.api.nvim_create_user_command("WordHintsToggle", M.toggle, {})
	render()
end

return M
