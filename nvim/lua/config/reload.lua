local M = {}

function M.reload()
	local ok, err = pcall(function()
		local modules = { "config.options", "config.keymaps", "config.autocmds" }
		local chunks = {}
		for _, name in ipairs(modules) do
			local path = "lua/" .. name:gsub("%.", "/") .. ".lua"
			local file = assert(vim.api.nvim_get_runtime_file(path, false)[1], "Missing " .. path)
			chunks[name] = assert(loadfile(file))
		end
		for _, name in ipairs(modules) do
			package.loaded[name] = chunks[name]() or true
		end
	end)
	if not ok then
		vim.notify("Configuration reload failed: " .. tostring(err), vim.log.levels.ERROR)
		return false
	end
	vim.notify("Options, keymaps, and autocmds reloaded", vim.log.levels.INFO)
	return true
end

return M
