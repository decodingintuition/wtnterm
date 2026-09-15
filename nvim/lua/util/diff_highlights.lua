local M = {}
local configured = false

function M.setup()
	if configured then
		return
	end

	local highlight = require("snacks.picker.util.highlight")
	local diff = require("snacks.picker.util.diff")
	local get_highlights = highlight.get_highlights
	local parse_hunk = diff.parse_hunk

	-- Match Neovim's handling of private Treesitter captures.
	highlight.get_highlights = function(opts)
		local rows = get_highlights(opts)
		for _, row in pairs(rows) do
			for i = #row, 1, -1 do
				local group = row[i].hl_group
				if type(group) == "string" and group:match("^@_") then
					table.remove(row, i)
				end
			end
		end
		return rows
	end

	-- Parse each revision separately to keep edited code syntactically coherent.
	diff.parse_hunk = function(ctx)
		local parsed = parse_hunk(ctx)
		if #parsed.versions ~= 2 or next(parsed.conflict_markers) then
			return parsed
		end
		if not vim.list_contains(parsed.prefixes, "-") or not vim.list_contains(parsed.prefixes, "+") then
			return parsed
		end

		for _, side in ipairs({ "-", "+" }) do
			local lines = { ctx.hunk.context or "" }
			local indices = {}
			for row, prefix in ipairs(parsed.prefixes) do
				if prefix == " " or prefix == side then
					lines[#lines + 1] = parsed.lines[row]
					indices[#lines] = row
				end
			end

			local ft = vim.filetype.match({ filename = ctx.block.file, contents = lines }) or ""
			local text = highlight.get_virtual_lines(table.concat(lines, "\n"), { ft = ft })
			for index, row in pairs(indices) do
				parsed.text[row] = text[index] or {}
			end
			if side == "+" then
				parsed.context = text[1] or parsed.context
			end
		end
		return parsed
	end

	configured = true
end

return M
