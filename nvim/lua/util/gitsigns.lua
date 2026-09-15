local M = {}

local function close_blame_if_open()
	-- Check if there's a blame buffer open by looking for buffers with 'gitsigns-blame' name pattern
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		local buf_name = vim.api.nvim_buf_get_name(buf)
		if buf_name:match("gitsigns://") or buf_name:match("blame") then
			-- Check if buffer is loaded and displayed in a window
			if vim.api.nvim_buf_is_loaded(buf) then
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					if vim.api.nvim_win_get_buf(win) == buf then
						vim.api.nvim_win_close(win, false)
						return true
					end
				end
			end
		end
	end
	return false
end

function M.toggle_blame()
	if close_blame_if_open() then
		return
	end
	-- Open blame with specific configuration
	require("gitsigns").blame({
		full = true,
		width = 40, -- Set narrower width
	})
end

return M