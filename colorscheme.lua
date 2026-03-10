-- noita

local bone      = "#c7c7c7"
local gold      = "#fff66d"
local fungus    = "#ee538c"
local mana      = "#6895f3"
local portal    = "#a75cd7"
local ambrosia  = "#d5ab34"
local sludge    = "#92b71c"
local tele      = "#85c6c6"
local lava      = "#f87d01"
local glyph     = "#ce2f26"
local blood     = "#dc5655"
local tablet    = "#76c395"
local ice       = "#7caaca"
local water     = "#7e9792"
local wasteland = "#20222d"
local mines     = "#111217"
local void      = "#010101"

return {
	colors = {
		foreground    = bone,
		background    = void,
		cursor_bg     = tele,
		cursor_fg     = void,
		cursor_border = tele,
		selection_bg  = mines,
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
			background = void,
			active_tab = {
				bg_color = mana,
				fg_color = void,
			},
			inactive_tab = {
				bg_color = water,
				fg_color = void,
			},
			inactive_tab_hover = {
				bg_color = wasteland,
				fg_color = void,
			},
			new_tab = {
				bg_color = void,
				fg_color = water,
			},
			new_tab_hover = {
				bg_color = mines,
				fg_color = bone,
			},
		},
	},
}
