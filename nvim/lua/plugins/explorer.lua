local window_size = require("util.window_size")

return {
	"folke/snacks.nvim",
	keys = {
		{ "<leader>e", require("util.explorer").git_root, desc = "Explorer (Git Root)" },
		{ "<leader>E", require("util.explorer").parent_dir, desc = "Explorer (Parent Dir)" },
	},
	opts = {
		picker = {
			sources = {
				explorer = {
					actions = {
						explorer_clear_filter = require("util.explorer").clear_filter,
					},
					layout = {
						hidden = { "input" },
						config = function(layout)
							local width = window_size.get("explorer", layout.layout.width)
							layout.layout.width = width
							layout.layout.min_width = math.min(layout.layout.min_width or width, width)
						end,
					},
					on_close = function(picker)
						local root = picker.layout and picker.layout.root
						if root and root:win_valid() then
							window_size.set("explorer", vim.api.nvim_win_get_width(root.win))
						end
					end,
					win = {
						input = {
							keys = {
								["<Esc>"] = { "explorer_clear_filter", mode = { "n", "i" } },
							},
						},
						list = {
							keys = {
								["."] = require("util.explorer").cd_to_focused,
								["/"] = "focus_input",
								["f"] = require("util.explorer").find_in_focused,
								["<BS>"] = require("util.explorer").cd_parent,
								["<C-s>"] = require("util.flash").anymode,
								["<Esc>"] = "explorer_clear_filter",
							},
						},
					},
				},
			},
		},
	},
}
