local map = vim.keymap.set

vim.api.nvim_create_user_command("BuildAs", function(opts)
	require("util.run").create(opts.fargs, opts)
end, { nargs = "+", range = true, desc = "Export selection/clipboard as executable" })

vim.api.nvim_create_user_command("ExecAs", function(opts)
	require("util.run").run(opts.fargs, opts)
end, { nargs = "+", range = true, desc = "Export selection/clipboard as executable and run" })

local function run_prompt(action, visual)
	return function()
		local code = nil
		if visual then
			local s = vim.fn.getpos("'<")
			local e = vim.fn.getpos("'>")
			local lines = vim.fn.getline(s[2], e[2])
			if type(lines) == "string" then lines = { lines } end
			code = #lines > 0 and table.concat(lines, "\n") or nil
		else
			local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
			code = #lines > 0 and table.concat(lines, "\n") or nil
		end
		vim.ui.input({ prompt = action == "build" and "Build: " or "Exec: " }, function(input)
			if not input or input == "" then return end
			local fargs = vim.split(input, "%s+")
			if action == "build" then
				require("util.run").create(fargs, nil, code)
			else
				require("util.run").run(fargs, nil, code)
			end
		end)
	end
end

map("n", "<leader>cb", run_prompt("build", false), { desc = "BuildAs" })
map("x", "<leader>cb", run_prompt("build", true), { desc = "BuildAs" })
map("n", "<leader>cx", run_prompt("exec", false), { desc = "ExecAs" })
map("x", "<leader>cx", run_prompt("exec", true), { desc = "ExecAs" })

-- Scroll
map("n", "<C-e>", "3<C-e>")
map("n", "<C-y>", "3<C-y>")

-- Window resize
map("n", "<C-Down>", "<cmd>resize +2<cr>")
map("n", "<C-Up>", "<cmd>resize -2<cr>")
map("n", "<C-Right>", "<cmd>vertical resize -2<cr>")
map("n", "<C-Left>", "<cmd>vertical resize +2<cr>")

-- Clear search highlighting
map("n", "<leader>/", "<cmd>nohlsearch<cr>", { desc = "Clear search highlighting" })

-- Yank paths
map("n", "<leader>yp", require("util.path").copy_git_relative_path, { desc = "Yank relative path" })
map("n", "<leader>yP", require("util.path").copy_git_relative_line, { desc = "Yank relative line" })
map("n", "<leader>ya", require("util.path").copy_absolute_path, { desc = "Yank absolute path" })
map("n", "<leader>yA", require("util.path").copy_absolute_line, { desc = "Yank absolute line" })
map("n", "<leader>yd", require("util.path").copy_absolute_directory, { desc = "Yank absolute directory" })

-- Navigate
map("n", "<leader><leader>", require("util.path").navigate, { desc = "Navigate to file or directory" })

-- Git
map("n", "<leader>gc", require("util.git").checkout_branch, { desc = "Checkout branch" })
map("n", "<leader>gyb", require("util.git").yank_current_branch, { desc = "Yank current branch" })
map("n", "<leader>gyB", require("util.git").yank_branch, { desc = "Yank branch (picker)" })
map("n", "<leader>gyc", require("util.git").yank_current_commit, { desc = "Yank current commit" })
map("n", "<leader>gyC", require("util.git").yank_commit, { desc = "Yank commit (picker)" })

-- Flash jump (any mode)
map(
	{ "n", "v", "i", "x", "o", "t", "c", "s" },
	"<C-s>",
	require("util.flash").anymode,
	{ desc = "Flash jump from any mode" }
)

-- ============================================================
-- LazyVim defaults (thinned down as needed)
-- ============================================================

-- Better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", function()
	Snacks.bufdelete()
end, { desc = "Delete Buffer" })
map("n", "<leader>bo", function()
	Snacks.bufdelete.other()
end, { desc = "Delete Other Buffers" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- Escape and clear hlsearch
map({ "i", "n", "s" }, "<esc>", function()
	vim.cmd("noh")
	return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- Redraw / clear hlsearch / diff update
map(
	"n",
	"<leader>ur",
	"<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
	{ desc = "Redraw / Clear hlsearch / Diff Update" }
)

-- Better indenting
map("x", "<", "<gv")
map("x", ">", ">gv")

-- Lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- New file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- Quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- Terminal
local function toggle_terminal()
	local window_size = require("util.window_size")
	Snacks.terminal(nil, {
		win = {
			height = window_size.get("terminal", 0.4),
			on_win = function(self)
				window_size.track(self, "terminal", "height")
			end,
		},
	})
end

map({ "n", "t" }, "<c-/>", toggle_terminal, { desc = "Terminal" })
map({ "n", "t" }, "<c-_>", toggle_terminal, { desc = "which_key_ignore" })

-- Windows
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- Tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
