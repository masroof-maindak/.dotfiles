local light = {
	base00 = "#F1E3D1", -- BG
	base01 = "#DDCEBC", -- BG2
	base02 = "#C9B9A7", -- BG3
	base03 = "#B5A492", -- Comments
	base04 = "#A0907D",
	base05 = "#64513E", -- FG
	base06 = "#786653",
	base07 = "#8C7B68",
	base08 = "#D09700", -- Variables
	base09 = "#64513E", -- numbers
	base0A = "#a73838", -- Classes
	base0B = "#8d8851", -- Strings
	base0C = "#d09700", -- Support
	base0D = "#BF7979", -- Functions
	base0E = "#9E5581", -- Keywords
	base0F = "#75858C", -- Parentheses
}

local dark = {
	base00 = "#242015",
	base01 = "#3A3124",
	base02 = "#4D3F32",
	base03 = "#5F4E41",
	base04 = "#B8A58C",
	base05 = "#D2C3A4",
	base06 = "#EBE0BB",
	base07 = "#F1E9D0",
	base08 = "#DB930D",
	base09 = "#EBE0BB",
	base0A = "#a93b5c",
	base0B = "#6f682c",
	base0C = "#DB930D",
	base0D = "#d45d67",
	base0E = "#91506C",
	base0F = "#A8663C",
}

local color_schemes = {
	["swamp-light"] = {
		background = light.base00,
		foreground = light.base05,
		cursor_fg = light.base02,
		cursor_border = light.base04,
		cursor_bg = light.base07,
		selection_fg = light.base04,
		selection_bg = light.base01,

		ansi = { light.base01, light.base0A, light.base0B, light.base0C, light.base0D, light.base0E, light.base0F, light.base02 },
		brights = { light.base00, light.base0A, light.base0B, light.base0C, light.base0D, light.base0E, light.base0F, light.base05 },

		tab_bar = {
			background = light.base00,

			active_tab = {
				bg_color = light.base06,
				fg_color = light.base02,
				intensity = "Normal", -- "Half", "Normal" or "Bold"
				underline = "None", -- "None", "Single" or "Double"
				italic = false,
				strikethrough = false,
			},

			inactive_tab = {
				fg_color = light.base06,
				bg_color = light.base01,
				intensity = "Normal",
			},

			inactive_tab_hover = {
				bg_color = dark.base06,
				fg_color = dark.base08,
				italic = true,
			},
		},
	},
	["swamp-dark"] = {
		foreground = dark.base06,
		background = dark.base00,
		cursor_bg = dark.base04,
		cursor_border = dark.base05,
		cursor_fg = dark.base00,
		selection_bg = dark.base05,
		selection_fg = dark.base01,

		ansi = { dark.base06, dark.base0A, dark.base0B, dark.base0C, dark.base0D, dark.base0E, dark.base0F, dark.base05 },
		brights = { dark.base00, dark.base0A, dark.base0B, dark.base08, dark.base0E, dark.base0D, dark.base0F, dark.base05 },

		tab_bar = {
			background = dark.base00,

			active_tab = {
				bg_color = dark.base08,
				fg_color = dark.base00,
				intensity = "Normal", -- "Half", "Normal" or "Bold"
				underline = "None", -- "None", "Single" or "Double"
				italic = false,
				strikethrough = false,
			},

			inactive_tab = {
				fg_color = dark.base05,
				bg_color = dark.base01,
				intensity = "Normal",
			},

			inactive_tab_hover = {
				bg_color = dark.base06,
				fg_color = dark.base08,
				italic = true,
			},
		},
	},
}

return color_schemes
