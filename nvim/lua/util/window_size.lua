local M = {}

local sizes = {}
local tracked = setmetatable({}, { __mode = "k" })

function M.get(key, default)
	return sizes[key] or default
end

function M.set(key, size)
	if type(size) == "number" and size > 0 then
		sizes[key] = size
	end
end

local function save(win, key, dimension)
	if not win:win_valid() then
		return
	end

	local size = dimension == "width" and vim.api.nvim_win_get_width(win.win)
		or vim.api.nvim_win_get_height(win.win)
	M.set(key, size)
	win.opts[dimension] = size
end

function M.track(win, key, dimension)
	if sizes[key] then
		win.opts[dimension] = sizes[key]
	end

	if tracked[win] then
		return
	end

	tracked[win] = true
	local on_close = win.opts.on_close
	win.opts.on_close = function(self)
		save(self, key, dimension)
		if on_close then
			return on_close(self)
		end
	end
	win:on("WinResized", function(self)
		save(self, key, dimension)
	end, { win = true })
	win:on("WinLeave", function(self)
		save(self, key, dimension)
	end, { buf = true })
end

return M
