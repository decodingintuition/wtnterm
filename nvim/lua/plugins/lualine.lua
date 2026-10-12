local recording_register = vim.fn.reg_recording()

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			theme = "noita",
		},
		sections = {
			lualine_x = {
				{
					function()
						return recording_register ~= "" and "REC @" .. recording_register or ""
					end,
					color = { fg = "#ff5555", bg = require("noita.palette").mines, gui = "bold" },
				},
				"encoding",
				"fileformat",
				"filetype",
			},
		},
	},
	config = function(_, opts)
		local lualine = require("lualine")
		recording_register = vim.fn.reg_recording()
		lualine.setup(opts)
		vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
			group = vim.api.nvim_create_augroup("LualineMacroRecording", { clear = true }),
			callback = function(event)
				-- Keep the indicator stable until recording explicitly ends.
				recording_register = event.event == "RecordingEnter" and vim.fn.reg_recording() or ""
				lualine.refresh({ place = { "statusline" } })
			end,
		})
	end,
}
