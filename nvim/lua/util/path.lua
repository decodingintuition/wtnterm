local M = {}

function M.git_root()
	local git_dir = vim.fn.finddir(".git", vim.fn.expand("%:p:h") .. ";")
	if git_dir == "" then
		return nil
	end
	return vim.fn.fnamemodify(git_dir, ":h")
end

function M.copy_absolute(line_num)
	local path = vim.fn.expand("%:p")
	local yanked_text = path
	if line_num then
		yanked_text = yanked_text .. "#L" .. line_num
	end
	vim.fn.setreg("+", yanked_text)
	vim.notify("Yanked: " .. yanked_text, vim.log.levels.INFO)
end

function M.copy_absolute_path()
	M.copy_absolute(nil)
end

function M.copy_absolute_line()
	M.copy_absolute(vim.fn.line("."))
end

function M.copy_absolute_directory()
	local yanked_text = vim.fn.expand("%:p:h")
	vim.fn.setreg("+", yanked_text)
	vim.notify("Yanked: " .. yanked_text, vim.log.levels.INFO)
end

function M.copy_git_relative(line_num)
	local full_path = vim.api.nvim_buf_get_name(0)
	local git_root = M.git_root()
	if git_root then
		local rel_path = vim.fn.fnamemodify(full_path, ":." .. git_root)
		local yanked_text = rel_path
		if line_num then
			yanked_text = yanked_text .. "#L" .. line_num
		end
		vim.fn.setreg("+", yanked_text)
		vim.notify("Yanked: " .. yanked_text, vim.log.levels.INFO)
	else
		M.copy_absolute(line_num)
	end
end

function M.copy_git_relative_path()
	M.copy_git_relative(nil)
end

function M.copy_git_relative_line()
	M.copy_git_relative(vim.fn.line("."))
end

function M.navigate()
	local input = vim.fn.input({
		prompt = "Open file or change directory: ",
		completion = "file",
	})
	if input and input ~= "" then
		input = input:match("^%s*(.-)%s*$")
		if input == "" then return end
		local expanded = vim.fn.expand(input)
		if vim.fn.isdirectory(expanded) == 1 then
			vim.cmd.cd(expanded)
		elseif vim.fn.filereadable(expanded) == 1 then
			vim.cmd.edit(expanded)
		else
			if input:sub(-1) == "/" then
				vim.fn.mkdir(expanded, "p")
				vim.cmd.cd(expanded)
			else
				if input:find("/") then
					local dir = vim.fn.fnamemodify(expanded, ":h")
					vim.fn.mkdir(dir, "p")
        else
          vim.cmd.edit(expanded)
        end
			end
		end
	end
end

return M
