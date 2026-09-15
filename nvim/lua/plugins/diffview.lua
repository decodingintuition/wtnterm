return {
	"sindrets/diffview.nvim",
	dependencies = "nvim-lua/plenary.nvim",
	keys = {
		{ "<leader>gv", require("util.diffview").view, desc = "DiffView", mode = { "n", "v" } },
		{ "<leader>gg", require("util.diffview").history, desc = "DiffHistory", mode = { "n", "v" } },
		{ "<leader>gG", require("util.diffview").history_full, desc = "DiffHistory", mode = { "n", "v" } },
		{ "<leader>gV", require("util.diffview").select, desc = "DiffSelect", mode = { "n", "v" } },
		{ "<leader>ga", require("util.diffview").git_log_author, desc = "GitLog by author" },
		{ "<leader>go", require("util.diffview").open_commit, desc = "DiffOpen", mode = { "n", "v" } },
		{
			"go",
			require("util.diffview").open_commit_visual,
			desc = "DiffOpen (selection)",
			mode = "v",
		},
		{
			"<leader>gO",
			require("util.diffview").open_commit_history,
			desc = "DiffOpen (history)",
			mode = { "n", "v" },
		},
	},
	opts = {
    diff_binaries = false,
		enhanced_diff_hl = true,
	},
	config = function(_, opts)
		require("diffview").setup(opts)
	end,
}
