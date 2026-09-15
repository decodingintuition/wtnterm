return {
	"folke/flash.nvim",
	opts = {
		prompt = { enabled = false },
		modes = {
			char = { enabled = false },
		},
	},
	keys = {
		{ "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
	},
}
