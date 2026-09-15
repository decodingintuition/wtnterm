local p = require("noita.palette")

return {
	normal = {
		a = { fg = p.void,  bg = p.portal,     gui = "bold" },
		b = { fg = p.bone,  bg = p.base },
		c = { fg = p.water, bg = p.mines },
	},
	insert = {
		a = { fg = p.void, bg = p.mana,     gui = "bold" },
	},
	visual = {
		a = { fg = p.void, bg = p.ambrosia, gui = "bold" },
	},
	replace = {
		a = { fg = p.void, bg = p.lava,     gui = "bold" },
	},
	command = {
		a = { fg = p.void, bg = p.fungus,   gui = "bold" },
	},
	terminal = {
		a = { fg = p.void, bg = p.tablet,   gui = "bold" },
	},
	inactive = {
		a = { fg = p.water, bg = p.wasteland },
		b = { fg = p.water, bg = p.wasteland },
		c = { fg = p.muted, bg = p.mines },
	},
}
