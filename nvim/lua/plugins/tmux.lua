local directions = {
	["<C-h>"] = { command = "TmuxNavigateLeft", desc = "Go to left pane" },
	["<C-j>"] = { command = "TmuxNavigateDown", desc = "Go to lower pane" },
	["<C-k>"] = { command = "TmuxNavigateUp", desc = "Go to upper pane" },
	["<C-l>"] = { command = "TmuxNavigateRight", desc = "Go to right pane" },
}

return {
	"christoomey/vim-tmux-navigator",
	lazy = false,
	init = function()
		vim.g.tmux_navigator_no_mappings = 1
	end,
	config = function()
		for key, mapping in pairs(directions) do
			vim.keymap.set({ "n", "i", "t" }, key, function()
				vim.cmd(mapping.command)
			end, { silent = true, desc = mapping.desc })
		end

		vim.keymap.set("n", "<C-\\>", "<Cmd>TmuxNavigatePrevious<CR>", {
			silent = true,
			desc = "Go to previous pane",
		})
	end,
}
