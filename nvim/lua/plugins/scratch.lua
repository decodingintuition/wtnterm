return {
	"folke/snacks.nvim",
	lazy = false,
	opts = {
		scratch = {
			win = {
				width = 0.7,
				height = 0.7,
				on_win = function(self)
					self:on("WinLeave", function()
						vim.schedule(function()
							if not self.win or not vim.api.nvim_win_is_valid(self.win) then return end
							local new_win = vim.api.nvim_get_current_win()
							if new_win == self.win then return end
							local cfg = vim.api.nvim_win_get_config(new_win)
							if cfg.relative ~= "" then return end
							self:close()
						end)
					end)
				end,
			},
		},
	},
	keys = {
		{
			"<leader>'",
			require("util.scratch").toggle,
			desc = "Toggle Scratch Buffer",
			mode = { "n", "x" },
		},
		{
			'<leader>"',
			require("util.scratch").menu,
			desc = "Scratch Buffer Menu",
			mode = { "n", "x" },
		},
	},
}
