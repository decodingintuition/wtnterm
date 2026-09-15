-- noita

local bone      = "#c7c7c7"
local gold      = "#fff66d"
local fungus    = "#f16d9d"
local mana      = "#6895f3"
local portal    = "#bb81e0"
local ambrosia  = "#d5ab34"
local sludge    = "#92b71c"
local tele      = "#85c6c6"
local lava      = "#f87d01"
local glyph     = "#d86761"
local blood     = "#e47b7a"
local tablet    = "#76c395"
local ice       = "#7caaca"
local water     = "#879e9a"
local base      = "#253138"
local wasteland = "#20222d"
local mines     = "#111217"
local void      = "#010101"

return {
	colors = {
		foreground    = bone,
		background    = mines,
		cursor_bg     = bone,
		cursor_fg     = void,
		cursor_border = bone,
		selection_bg  = base,
		selection_fg  = bone,
		ansi = {
			void,      -- 0  black
			glyph,     -- 1  red
			sludge,    -- 2  green
			ambrosia,  -- 3  yellow
			mana,      -- 4  blue
			fungus,    -- 5  magenta
			tele,      -- 6  cyan
			bone,      -- 7  white
		},
		brights = {
			water,     -- 8  bright black
			blood,     -- 9  bright red
			tablet,    -- 10 bright green
			gold,      -- 11 bright yellow
			ice,       -- 12 bright blue
			lava,      -- 13 bright magenta
			portal,    -- 14 bright cyan
			bone,      -- 15 bright white
		},
		tab_bar = {
			background = mines,
			active_tab = {
				bg_color = mana,
				fg_color = void,
			},
			inactive_tab = {
				bg_color = base,
				fg_color = bone,
			},
			inactive_tab_hover = {
				bg_color = wasteland,
				fg_color = bone,
			},
			new_tab = {
				bg_color = mines,
				fg_color = water,
			},
			new_tab_hover = {
				bg_color = mines,
				fg_color = bone,
			},
		},
	},
}
