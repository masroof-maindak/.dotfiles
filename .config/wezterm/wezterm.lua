local wezterm = require("wezterm")
local appearance = require("appearance")
local config = {}

config.font = wezterm.font("Berkeley Mono Condensed")
if appearance.is_dark() then
	config.color_scheme = "swamp-dark"
else
	config.color_scheme = "swamp-light"
end
config.font_size = 12
config.window_padding = { left = 15, right = 15, top = 15, bottom = 15 }
config.window_close_confirmation = "NeverPrompt"

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.switch_to_last_active_tab_when_closing_tab = true
config.show_new_tab_button_in_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 50

config.color_schemes = require("swamp")

config.inactive_pane_hsb = { saturation = 1.0, brightness = 1.0 }

return config
