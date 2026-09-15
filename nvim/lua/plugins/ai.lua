return {
	"folke/snacks.nvim",
	keys = {
		{
			"<C-]><C-]>",
			function()
				require("util.ai").focus_toggle()
			end,
			desc = "AI Focus",
			mode = { "n", "x", "t" },
		},
		{
			"<C-]>m",
			function()
				require("util.ai").select()
			end,
			desc = "Select AI",
			mode = { "n", "x", "t" },
		},
		{
			"<C-]>r",
			function()
				require("util.ai").resume()
			end,
			desc = "AI Resume",
			mode = { "n", "x", "t" },
		},
		{
			"<C-]>y",
			function()
				require("util.ai").send_selection()
			end,
			desc = "AI Send",
			mode = { "n", "x" },
		},
	},
}
