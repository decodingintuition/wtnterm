local M = {}

function M.force_normal_mode(callback)
	if vim.fn.mode() ~= "n" then
		local escape_keys = vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, false, true)
		vim.api.nvim_feedkeys(escape_keys, vim.fn.mode(), false)
		if callback then
			vim.defer_fn(callback, 20)
		end
	elseif callback then
		callback()
	end
end

function M.anymode()
	M.force_normal_mode(function()
		require("flash").jump({
			action = function(match, state)
				function do_jump()
					require("flash.jump").jump(match, state)
				end
				do_jump()
				vim.defer_fn(function()
					M.force_normal_mode(do_jump)
				end, 50)
			end,
		})
	end)
end

return M
