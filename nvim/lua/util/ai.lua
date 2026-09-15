local M = {}
local window_size = require("util.window_size")

local terminals = {}

M.config = {
	provider = "codex",
	split_side = "right",
	split_width = 0.3,
	focus_key = "<C-]><C-]>",
	select_key = "<C-]>m",
	providers = {
		claude = {
			label = "Claude",
			cmd = { "claude", "--dangerously-skip-permissions" },
			resume = { "--resume" },
		},
		codex = {
			label = "Codex",
			cmd = {
				"codex",
				"--dangerously-bypass-approvals-and-sandbox",
				"--model",
				"gpt-6-astra",
			},
			resume = { "resume" },
			reasoning = "high",
			reasoning_levels = { "low", "medium", "high", "xhigh", "max", "ultra" },
		},
	},
}

local function is_open(name)
	local terminal = terminals[name]
	return terminal ~= nil and terminal:buf_valid()
end

local function command(name, args)
	local provider = assert(M.config.providers[name], "Unknown AI provider: " .. name)
	local cmd = vim.deepcopy(provider.cmd)
	if provider.reasoning then
		vim.list_extend(cmd, { "-c", "model_reasoning_effort=" .. provider.reasoning })
	end
	return vim.list_extend(cmd, args or {})
end

local function open(name, args)
	local provider = M.config.providers[name]
	local terminal = Snacks.terminal.open(command(name, args), {
		start_insert = true,
		auto_insert = true,
		auto_close = false,
		win = {
			position = M.config.split_side,
			width = window_size.get("ai", M.config.split_width),
			height = 0,
			relative = "editor",
			on_win = function(self)
				window_size.track(self, "ai", "width")
			end,
			keys = {
				ai_hide = {
					M.config.focus_key,
					function(self)
						self:hide()
					end,
					mode = "t",
					desc = "Hide AI",
				},
				ai_select = {
					M.config.select_key,
					function()
						M.select()
					end,
					mode = "t",
					desc = "Select AI",
				},
			},
		},
	})
	if not (terminal and terminal:buf_valid()) then
		vim.notify("Failed to open " .. provider.label, vim.log.levels.ERROR)
		return nil
	end
	terminal:on("TermClose", function()
		terminals[name] = nil
		vim.schedule(function()
			terminal:close({ buf = true })
			vim.cmd.checktime()
		end)
	end, { buf = true })
	terminal:on("BufWipeout", function()
		terminals[name] = nil
	end, { buf = true })
	terminals[name] = terminal
	return terminal
end

local function focus(name)
	local terminal = terminals[name]
	if not terminal:win_valid() then
		terminal:show()
	end
	if terminal.win and vim.api.nvim_win_is_valid(terminal.win) then
		vim.api.nvim_set_current_win(terminal.win)
		vim.cmd.startinsert()
	end
end

local function focus_provider(name)
	if is_open(name) then
		focus(name)
	else
		open(name)
	end
end

function M.focus_toggle()
	local name = M.config.provider
	local terminal = terminals[name]
	if is_open(name) and terminal:win_valid() and terminal.win == vim.api.nvim_get_current_win() then
		terminal:hide()
	else
		focus_provider(name)
	end
end

function M.resume()
	local name = M.config.provider
	if is_open(name) then
		focus(name)
	else
		open(name, M.config.providers[name].resume)
	end
end

function M.close(name)
	local terminal = terminals[name]
	terminals[name] = nil
	if terminal and terminal:buf_valid() then
		terminal:close({ buf = true })
	end
end

function M.launch(name, args)
	assert(M.config.providers[name], "Unknown AI provider: " .. name)
	M.close(name)
	M.config.provider = name
	return open(name, args)
end

function M.select_reasoning()
	local provider = M.config.providers.codex
	vim.ui.select(provider.reasoning_levels, {
		prompt = "Codex reasoning:",
		format_item = function(reasoning)
			local selected = reasoning == provider.reasoning and " ✓" or ""
			return reasoning:upper() .. selected
		end,
	}, function(reasoning)
		if reasoning then
			provider.reasoning = reasoning
		end
	end)
end

function M.select()
	local providers = { "claude", "codex" }
	vim.ui.select(providers, {
		prompt = "AI provider:",
		format_item = function(name)
			return M.config.providers[name].label
		end,
	}, function(name)
		if not name then
			return
		end
		local previous = M.config.provider
		if previous ~= name and is_open(previous) and terminals[previous]:win_valid() then
			terminals[previous]:hide()
		end
		M.config.provider = name
		if name == "codex" then
			M.select_reasoning()
		end
	end)
end

local function send_text(text)
	local name = M.config.provider
	if is_open(name) then
		vim.api.nvim_chan_send(vim.bo[terminals[name].buf].channel, text)
		focus(name)
	else
		local terminal = open(name)
		if not terminal then
			return
		end
		vim.defer_fn(function()
			if is_open(name) then
				vim.api.nvim_chan_send(vim.bo[terminals[name].buf].channel, text)
			end
		end, 700)
	end
end

function M.send_selection()
	local path = vim.fn.expand("%:.")
	if path == "" then
		vim.notify("No file for current buffer", vim.log.levels.WARN)
		return
	end
	local first = vim.fn.line("v")
	local last = vim.fn.line(".")
	if first > last then
		first, last = last, first
	end
	if vim.fn.mode():match("[vV\22]") then
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
	end
	local ref = first == last and (path .. ":" .. first) or (path .. ":" .. first .. "-" .. last)
	send_text(ref .. " ")
end

return M
