-- lua/custom/word-hints.lua
-- Shows virtual text with W/B jump counts (like relative line numbers, but horizontal)

local M = {}

local ns = vim.api.nvim_create_namespace("word_hints")

local config = {
	enabled = true,
	debounce_ms = 50,
	max_words = 20,
	forward_hl = "Comment",
	backward_hl = nil, -- falls back to forward_hl
	-- "all" = every word, "power" = only multiples of 5
	mode = "all",
	forward_fmt = "%d",
	backward_fmt = "%d",
}

local function word_starts(lnum)
	local line = vim.api.nvim_buf_get_lines(0, lnum, lnum + 1, false)[1]
	if not line then
		return {}
	end
	local positions = {}
	local in_word = false
	for i = 1, #line do
		local ws = line:sub(i, i):match("%s") ~= nil
		if not ws and not in_word then
			positions[#positions + 1] = i - 1
		end
		in_word = not ws
	end
	return positions
end

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

	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	row = row - 1

	local bwd_hl = config.backward_hl or config.forward_hl

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

	-- current line: forward
	local starts = word_starts(row)
	local fwd_count = 0
	for _, wc in ipairs(starts) do
		if wc > col and fwd_count < config.max_words then
			fwd_count = fwd_count + 1
			place(row, wc, fwd_count, config.forward_hl, config.forward_fmt)
		end
	end

	-- current line: backward
	local bwd_count = 0
	for i = #starts, 1, -1 do
		local wc = starts[i]
		if wc < col and bwd_count < config.max_words then
			bwd_count = bwd_count + 1
			place(row, wc, bwd_count, bwd_hl, config.backward_fmt)
		end
	end

	-- lines below: forward overflow
	if fwd_count < config.max_words then
		local total = vim.api.nvim_buf_line_count(buf)
		for lnum = row + 1, math.min(total - 1, row + 30) do
			if fwd_count >= config.max_words then
				break
			end
			for _, wc in ipairs(word_starts(lnum)) do
				if fwd_count >= config.max_words then
					break
				end
				fwd_count = fwd_count + 1
				place(lnum, wc, fwd_count, config.forward_hl, config.forward_fmt)
			end
		end
	end

	-- lines above: backward overflow
	if bwd_count < config.max_words then
		for lnum = row - 1, math.max(0, row - 30), -1 do
			if bwd_count >= config.max_words then
				break
			end
			local ls = word_starts(lnum)
			for i = #ls, 1, -1 do
				if bwd_count >= config.max_words then
					break
				end
				bwd_count = bwd_count + 1
				place(lnum, ls[i], bwd_count, bwd_hl, config.backward_fmt)
			end
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
