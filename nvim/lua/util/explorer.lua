local M = {}

local function pick_nearest_dir()
	local picker = Snacks.picker.get({ source = "explorer" })[1]
	return picker and picker:dir() or vim.fn.getcwd()
end

local function change_dir(dir)
	vim.cmd("cd " .. vim.fn.fnameescape(dir))
end

local function open_explorer_at(dir)
	if dir then
		change_dir(dir)
	end
	Snacks.explorer()
end

function M.cd_to_focused()
	local dir = pick_nearest_dir()
	change_dir(dir)
end

function M.cd_parent()
	local parent_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":h")
	change_dir(parent_dir)
end

function M.parent_dir()
	open_explorer_at(vim.fn.expand("%:p:h"))
end

function M.git_root()
	open_explorer_at(require("util.path").git_root())
end

function M.find_in_focused()
	local dir = pick_nearest_dir()
	Snacks.picker.files({ cwd = dir })
end

function M.clear_filter(picker)
	picker:norm(function()
		picker.input:set("", "")
		picker:find()
		picker:focus("list")
		picker:toggle("input", { enable = false })
	end)
end

return M
