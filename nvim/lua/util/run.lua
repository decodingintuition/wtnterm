local M = {}

local cache_dir = vim.fn.expand("~/.cache/nvim-run")
local scripts_dir = vim.fn.stdpath("config") .. "/run"
local extras_dir = vim.fn.stdpath("config") .. "/run-extras"

local function get_code(opts, code)
	if code then return code end
	if opts and opts.range == 2 then
		local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
		return table.concat(lines, "\n")
	end
	local clip = vim.fn.getreg("+")
	if clip == "" then vim.notify("Clipboard is empty", vim.log.levels.WARN); return nil end
	return clip
end

local function build(fargs, code)
	local name = fargs[1]
	if not name:match("%.") then name = "run." .. name end
	local ext = name:match("%.(%w+)$")

	local script = extras_dir .. "/" .. ext .. ".sh"
	if vim.fn.filereadable(script) == 0 then
		script = scripts_dir .. "/" .. ext .. ".sh"
	end
	if vim.fn.filereadable(script) == 0 then
		vim.notify("No runner for ." .. ext, vim.log.levels.WARN); return nil
	end

	vim.fn.mkdir(cache_dir, "p")
	local cmd = { "bash", script, cache_dir .. "/" .. name }
	for i = 2, #fargs do table.insert(cmd, fargs[i]) end
	local result = vim.fn.system(cmd, code)
	if vim.v.shell_error ~= 0 then
		vim.notify("Error:\n" .. result, vim.log.levels.ERROR); return nil
	end
	return vim.trim(result)
end

function M.create(fargs, opts, code)
	code = get_code(opts, code)
	if not code then return end
	local path = build(fargs, code)
	if not path then return end
	vim.fn.setreg("+", path)
	vim.notify(path)
end

function M.run(fargs, opts, code)
	code = get_code(opts, code)
	if not code then return end
	local path = build(fargs, code)
	if not path then return end
	local output = vim.fn.system(path)
	if vim.v.shell_error ~= 0 then
		vim.notify("Runtime error:\n" .. output, vim.log.levels.ERROR); return
	end
	vim.notify(output)
end

return M
