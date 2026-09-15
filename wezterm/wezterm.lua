local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- -----------------------------------------
-- THEME: noita
-- -----------------------------------------

local colorscheme = dofile(wezterm.home_dir .. "/.config/wezterm/colorscheme.lua")
local colors = colorscheme.colors
config.colors = colors

-- -----------------------------------------
-- GLOBAL SETTINGS
-- -----------------------------------------

config.font = wezterm.font("JetBrains Mono")
config.font_size = 12
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.audible_bell = "Disabled"
config.window_close_confirmation = "NeverPrompt"
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

-- -----------------------------------------
-- STATUS BAR
-- -----------------------------------------

wezterm.on("update-status", function(window)
	if window:active_key_table() == "tab_leader" then
		window:set_left_status(wezterm.format({
			{ Background = { Color = colors.ansi[3] } },
			{ Foreground = { Color = colors.tab_bar.background } },
			{ Text = " PREFIX " },
			{ Background = { Color = colors.tab_bar.background } },
			{ Text = " " },
		}))
	else
		window:set_left_status("")
	end
end)

-- -----------------------------------------
-- TAB BAR
-- -----------------------------------------

wezterm.on("format-tab-title", function(tab)
	local title = (tab.tab_title and #tab.tab_title > 0) and tab.tab_title or tab.active_pane.title
	local index = tab.tab_index + 1
	local badge_bg = tab.is_active and colors.tab_bar.active_tab.bg_color or colors.tab_bar.inactive_tab.bg_color
	local badge_fg = tab.is_active and colors.tab_bar.active_tab.fg_color or colors.tab_bar.inactive_tab.fg_color

	return {
		{ Background = { Color = badge_bg } },
		{ Foreground = { Color = badge_fg } },
		{ Text = " " .. index .. " " },
		{ Background = { Color = colors.tab_bar.background } },
		{ Foreground = { Color = colors.foreground } },
		{ Text = title .. "  " },
	}
end)

-- -----------------------------------------
-- KEYBINDINGS
-- -----------------------------------------

local tab_leader = {
	{
		key = "c",
		action = act.PromptInputLine({
			description = "Name:",
			action = wezterm.action_callback(function(window, pane, name)
				if name then
					window:perform_action(act.SpawnTab("CurrentPaneDomain"), pane)
					window:active_tab():set_title(name)
				end
			end),
		}),
	},
	{
		key = "n",
		action = act.PromptInputLine({
			description = "Rename:",
			action = wezterm.action_callback(function(window, pane, name)
				if name then
					window:active_tab():set_title(name)
				end
			end),
		}),
	},
	{ key = "x", action = act.CloseCurrentTab({ confirm = true }) },
	{
		key = "w",
		action = act.PromptInputLine({
			description = "Move to index:",
			action = wezterm.action_callback(function(window, pane, input)
				if input then
					window:perform_action(act.MoveTab(tonumber(input) - 1), pane)
				end
			end),
		}),
	},
	{ key = "r", action = act.ReloadConfiguration },
	{ key = "Tab", action = act.Nop },
}

for i = 1, 9 do
	table.insert(tab_leader, { key = tostring(i), action = act.ActivateTab(i - 1) })
end

config.key_tables = { tab_leader = tab_leader }

local keys = {
	-- Tab Leader
	{ key = "Tab", mods = "CTRL", action = act.ActivateKeyTable({ name = "tab_leader", one_shot = true }) },
}

for i = 1, 9 do
	local key = tostring(i)
	table.insert(keys, { key = key, mods = "CTRL", action = act.ActivateTab(i - 1) })
	table.insert(keys, { key = key, mods = "CMD", action = act.SendString("\x00" .. key) })
end

-- Copy/Paste
table.insert(keys, { key = "c", mods = "CMD", action = act.CopyTo("Clipboard") })
table.insert(keys, { key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") })

-- Font Size
table.insert(keys, { key = "=", mods = "CTRL", action = act.IncreaseFontSize })
table.insert(keys, { key = "-", mods = "CTRL", action = act.DecreaseFontSize })

config.keys = keys

-- Zen mode font size (driven by zen-mode.nvim via ZEN_MODE user var)
wezterm.on("user-var-changed", function(window, pane, name, value)
	if name == "ZEN_MODE" then
		local overrides = window:get_config_overrides() or {}
		local n = tonumber((value:gsub("%s+", "")))
		if n and n > 0 then
			overrides.font_size = config.font_size + n
		else
			overrides.font_size = nil
		end
		window:set_config_overrides(overrides)
	end
end)

return config
