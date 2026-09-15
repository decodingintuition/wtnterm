local M = {}

local last_commit = false
local last_open_commit = false
local commit_history = {} -- { { hash = "...", title = "..." }, ... }

local function add_to_history(hash)
	vim.fn.system("git cat-file -t " .. hash)
	if vim.v.shell_error ~= 0 then
		return false
	end
	hash = vim.trim(vim.fn.system("git rev-parse --short " .. hash))
	local title = vim.trim(vim.fn.system("git log -1 --format=%s " .. hash))
	for i, entry in ipairs(commit_history) do
		if entry.hash == hash then
			table.remove(commit_history, i)
			break
		end
	end
	table.insert(commit_history, 1, { hash = hash, title = title })
	return true
end

local function pick_commit(hash)
	last_open_commit = hash
	local title = vim.trim(vim.fn.system("git log -1 --format=%s " .. hash))
	Snacks.picker.git_diff({
		cmd_args = { hash .. "^", hash },
		staged = false,
		group = true,
		title = hash .. " " .. title,
	})
end

local function close_if_open()
	if next(require("diffview.lib").views) ~= nil then
		vim.cmd("DiffviewClose")
		return true
	end
	return false
end

function M.view()
	if close_if_open() then
		return
	end
	if last_commit then
		vim.cmd("DiffviewOpen " .. last_commit)
	else
		vim.cmd("DiffviewOpen")
	end
end

function M.history()
	if close_if_open() then
		return
	end
	local current_file = vim.fn.expand("%")
	if current_file == "" then
		vim.notify("No file in current buffer", vim.log.levels.WARN)
		return
	end
	vim.cmd("DiffviewFileHistory " .. current_file)
end

function M.history_full()
	if close_if_open() then
		return
	end
	vim.cmd("DiffviewFileHistory")
end

function M.open_commit()
	if not last_open_commit then
		Snacks.picker.git_status()
	else
		pick_commit(last_open_commit)
	end
end

function M.open_commit_visual()
	local anchor = vim.fn.getpos("v")
	local cursor = vim.fn.getpos(".")
	local l1, c1 = anchor[2], anchor[3]
	local l2, c2 = cursor[2], cursor[3]
	if l1 > l2 or (l1 == l2 and c1 > c2) then
		l1, c1, l2, c2 = l2, c2, l1, c1
	end
	local lines = vim.api.nvim_buf_get_text(0, l1 - 1, c1 - 1, l2 - 1, c2, {})
	local text = vim.trim(table.concat(lines, ""))
	if text:match("^%x+$") and #text >= 7 and #text <= 40 then
		if add_to_history(text) then
			pick_commit(text)
		end
	else
		vim.notify("Not a valid commit hash: " .. text, vim.log.levels.WARN)
	end
end

function M.git_log_author()
	vim.ui.input({ prompt = "Author: " }, function(author)
		if not author or author == "" then
			return
		end
		local output =
			vim.fn.system("git log --author=" .. vim.fn.shellescape(author) .. " --oneline -50 --pretty=format:'%h|%s'")
		if vim.v.shell_error ~= 0 or output == "" then
			vim.notify("No commits found for author: " .. author, vim.log.levels.WARN)
			return
		end
		local labels, hashes = {}, {}
		for line in output:gmatch("[^\n]+") do
			local hash, title = line:match("^([a-f0-9]+)|(.+)")
			if hash and title then
				table.insert(labels, hash .. " " .. title)
				table.insert(hashes, hash)
			end
		end
		vim.ui.select(labels, { prompt = "Commits by " .. author .. ":" }, function(choice, idx)
			if not choice then
				return
			end
			local hash = hashes[idx]
			add_to_history(hash)
			pick_commit(hash)
		end)
	end)
end

function M.open_commit_history()
	local clip = vim.trim(vim.fn.getreg("+"))
	if clip:match("^%x+$") and #clip >= 7 and #clip <= 40 then
		add_to_history(clip) -- silently attempts; notification shown if invalid
	end

	local labels = { "━━ View Staged/Unstaged ━━" }
	local hashes = { false }

	for _, entry in ipairs(commit_history) do
		table.insert(labels, entry.hash .. " " .. entry.title)
		table.insert(hashes, entry.hash)
	end

	vim.ui.select(labels, { prompt = "Open commit:" }, function(choice, idx)
		if not choice then
			return
		end
		local hash = hashes[idx]
		if hash then
			pick_commit(hash)
		else
			last_open_commit = false
			Snacks.picker.git_status()
		end
	end)
end

function M.select()
	if close_if_open() then
		return
	end

	-- Get recent commits with hash and title
	local git_cmd = "git log --oneline -50 --pretty=format:'%h|%s'"
	local output = vim.fn.system(git_cmd)

	if vim.v.shell_error ~= 0 then
		vim.notify("Error getting git commits", vim.log.levels.ERROR)
		return
	end

	local commits = { "━━ View Staged/Unstaged ━━" }
	local commit_hashes = { false }

	for line in output:gmatch("[^\n]+") do
		local hash, title = line:match("^([a-f0-9]+)|(.+)")
		if hash and title then
			table.insert(commits, title)
			table.insert(commit_hashes, hash)
		end
	end

	vim.ui.select(commits, { prompt = "Diff with commit:" }, function(choice, idx)
		if choice and idx then
			last_commit = commit_hashes[idx]
			M.view()
		end
	end)
end

return M
