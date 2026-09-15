local M = {}

function M.checkout_branch()
	-- Get local branches
	local git_cmd = "git branch -l"
	local output = vim.fn.system(git_cmd)

	if vim.v.shell_error ~= 0 then
		vim.notify("Error getting git branches", vim.log.levels.ERROR)
		return
	end

	local branches = {}
	local current_branch = vim.fn.system("git branch --show-current"):gsub("\n", "")

	for line in output:gmatch("[^\n]+") do
		local branch = line:gsub("^%s*%*?%s*", "") -- remove leading spaces and current branch marker
		if branch ~= "" then
			table.insert(branches, branch)
		end
	end

	if #branches == 0 then
		vim.notify("No branches found", vim.log.levels.WARN)
		return
	end

	vim.ui.select(branches, { prompt = "Checkout branch:" }, function(choice)
		if choice and choice ~= current_branch then
			local checkout_cmd = string.format("git checkout %s", vim.fn.shellescape(choice))
			local result = vim.fn.system(checkout_cmd)

			if vim.v.shell_error == 0 then
				vim.notify("Switched to branch: " .. choice, vim.log.levels.INFO)
			else
				vim.notify("Error checking out branch: " .. result, vim.log.levels.ERROR)
			end
		end
	end)
end

function M.yank_current_branch()
	local current_branch = vim.fn.system("git branch --show-current"):gsub("\n", "")

	if vim.v.shell_error ~= 0 then
		vim.notify("Error getting current branch", vim.log.levels.ERROR)
		return
	end

	if current_branch == "" then
		vim.notify("No current branch found", vim.log.levels.WARN)
		return
	end

	vim.fn.setreg("+", current_branch)
	vim.notify("Yanked current branch: " .. current_branch, vim.log.levels.INFO)
end

function M.yank_branch()
	-- Get local branches
	local git_cmd = "git branch -l"
	local output = vim.fn.system(git_cmd)

	if vim.v.shell_error ~= 0 then
		vim.notify("Error getting git branches", vim.log.levels.ERROR)
		return
	end

	local branches = {}

	for line in output:gmatch("[^\n]+") do
		local branch = line:gsub("^%s*%*?%s*", "") -- remove leading spaces and current branch marker
		if branch ~= "" then
			table.insert(branches, branch)
		end
	end

	if #branches == 0 then
		vim.notify("No branches found", vim.log.levels.WARN)
		return
	end

	vim.ui.select(branches, { prompt = "Yank branch:" }, function(choice)
		if choice then
			vim.fn.setreg("+", choice)
			vim.notify("Yanked branch: " .. choice, vim.log.levels.INFO)
		end
	end)
end

function M.yank_current_commit()
	local current_commit = vim.fn.system("git rev-parse HEAD"):gsub("\n", "")

	if vim.v.shell_error ~= 0 then
		vim.notify("Error getting current commit", vim.log.levels.ERROR)
		return
	end

	if current_commit == "" then
		vim.notify("No current commit found", vim.log.levels.WARN)
		return
	end

	vim.fn.setreg("+", current_commit)
	vim.notify("Yanked current commit: " .. current_commit:sub(1, 8), vim.log.levels.INFO)
end

function M.yank_commit()
	-- Get recent commits with hash and title
	local git_cmd = "git log --oneline -50 --pretty=format:'%h|%s'"
	local output = vim.fn.system(git_cmd)

	if vim.v.shell_error ~= 0 then
		vim.notify("Error getting git commits", vim.log.levels.ERROR)
		return
	end

	local commits = {}
	local commit_hashes = {}

	for line in output:gmatch("[^\n]+") do
		local hash, title = line:match("^([a-f0-9]+)|(.+)")
		if hash and title then
			table.insert(commits, title)
			table.insert(commit_hashes, hash)
		end
	end

	if #commits == 0 then
		vim.notify("No commits found", vim.log.levels.WARN)
		return
	end

	vim.ui.select(commits, { prompt = "Yank commit:" }, function(choice, idx)
		if choice and idx then
			local commit_hash = commit_hashes[idx]
			vim.fn.setreg("+", commit_hash)
			vim.notify("Yanked commit: " .. commit_hash, vim.log.levels.INFO)
		end
	end)
end

return M