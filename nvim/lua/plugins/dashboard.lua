return {
	"folke/snacks.nvim",
	lazy = false,
	priority = 900,
	opts = {
		-- Enable core utility modules
		bufdelete = { enabled = true },
		debug = { enabled = true },
		gitbrowse = { enabled = true },
		indent = { enabled = true },
		notifier = { enabled = true },
		scope = { enabled = true, treesitter = { injections = false } },
		scroll = { enabled = true },
		terminal = { enabled = true },
		toggle = { enabled = true },
		words = { enabled = true },
		zen = { enabled = true },
		-- Input
		input = { enabled = true },
		-- Dashboard
		dashboard = {
			preset = {
				pick = function(cmd, opts)
					return function()
						Snacks.picker[cmd](opts or {})
					end
				end,
				keys = {},
			},
			sections = {
				{
					align = "center",
					padding = 1,
					text = {
						{ "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗\n", hl = "Gradient1" },
						{ "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║\n", hl = "Gradient2" },
						{ "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║\n", hl = "Gradient3" },
						{ "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║\n", hl = "Gradient4" },
						{ "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║\n", hl = "Gradient5" },
						{ "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝", hl = "Gradient6" },
					},
				},
				{ section = "keys", gap = 1, padding = 1 },
				{ section = "startup" },
			},
		},
	},
	config = function(_, opts)
		-- Dashboard header gradient: honey → danger (gold to red)
		vim.api.nvim_set_hl(0, "Gradient1", { fg = "#c89030" })
		vim.api.nvim_set_hl(0, "Gradient2", { fg = "#cd7d30" })
		vim.api.nvim_set_hl(0, "Gradient3", { fg = "#d26a30" })
		vim.api.nvim_set_hl(0, "Gradient4", { fg = "#d65630" })
		vim.api.nvim_set_hl(0, "Gradient5", { fg = "#db4330" })
		vim.api.nvim_set_hl(0, "Gradient6", { fg = "#e03030" })
		require("snacks").setup(opts)
		require("util.diff_highlights").setup()
	end,
	keys = {
		{
			"<leader>un",
			function()
				Snacks.notifier.hide()
			end,
			desc = "Dismiss All Notifications",
		},
	},
}
