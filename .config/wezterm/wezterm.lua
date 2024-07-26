local wezterm = require("wezterm")
local config = {}

-- config.font = wezterm.font('CozetteHiDpi')
-- config.font = wezterm.font('Maple Mono')
config.font = wezterm.font('IBM Plex Mono')
-- config.font = wezterm.font('azuki_font')
config.line_height = 1.0
config.color_scheme = "swamp-light"
-- config.color_scheme = "swamp"
config.font_size = 10

-- config.background = {{
--         source = {File = '/home/maindak/Desktop/termTile.png'},
--         height= "36",
--         width= "36",
--     }
-- }
config.window_padding = { left = 25, right = 25, top = 25, bottom = 25 }
config.window_close_confirmation = "NeverPrompt"

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.switch_to_last_active_tab_when_closing_tab = true
config.show_new_tab_button_in_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 50

local BG = "#f1e3d1"
local activeFG = "#c9b9a7"
local activeBG = "#786653"
local inactiveFG = "#786653"
local inactiveBG = "#ddcebc"
if config.color_scheme == "swamp" then
	BG = "#242015"
	activeFG = "#242015"
	activeBG = "#db930d"
	inactiveFG = "#d2c3a4"
	inactiveBG = "#3a3124"
end

config.colors = {
	tab_bar = {
		background = BG,

		active_tab = {
			bg_color = activeBG,
			fg_color = activeFG,
			intensity = "Normal", -- "Half", "Normal" or "Bold"
			underline = "None", -- "None", "Single" or "Double"
			italic = false,
			strikethrough = false,
		},

		inactive_tab = {
			fg_color = inactiveFG,
			bg_color = inactiveBG,
			intensity = "Normal",
		},

		inactive_tab_hover = {
			bg_color = "#ebe0bb",
			fg_color = "#db930d",
			italic = true,
		},
	},
}

config.color_schemes = {
	["swamp-light"] = {
		background = "#f1e3d1",
		foreground = "#64513e",
		cursor_fg = "#c2b2a0",
		cursor_border = "#a3927f",
		cursor_bg = "#83715f",
		selection_fg = "#a3927f",
		selection_bg = "#D2C3B0",

		ansi = { "#64513e", "#993333", "#908D6A", "#da9e01", "#bf7979", "#9e5581", "#75858c", "#D2C3B0" },
		brights = { "#64513e", "#993333", "#908D6A", "#da9e01", "#bf7979", "#9e5581", "#75858c", "#f1e3d1" },
	},
	["swamp"] = {
		foreground = "#ebe0bb",
		background = "#242015",
		cursor_bg = "#b8a58C",
		cursor_border = "#d2c3a4",
		cursor_fg = "#211d13",
		selection_bg = "#d2c3a4",
		selection_fg = "#3a3124",

		ansi = { "#211d13", "#a82d56", "#7a7653", "#db930d", "#91506c", "#c1666b", "#508991", "#d2c3a4" },
		brights = { "#ebe0bb", "#96294d", "#736f4e", "#e69a0e", "#80465f", "#b05d61", "#61a0a8", "#d2c3a4" },
	},
}

config.inactive_pane_hsb = { saturation = 1.0, brightness = 1.0 }

return config
