-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = "AdventureTime"
--
--

config.font = wezterm.font("DejaVuSansMono NF", { weight = "Medium", stretch = "Expanded" })
config.font_size = 13

-- from https://github.com/wez/wezterm/issues/4051#issue-1820224035
-- if wezterm.gui.get_appearance():find("Dark") then
-- 	-- config.color_scheme = "Catppuccin Mocha"
-- 	-- config.color_scheme = "Tartan (terminal.sexy)"
-- end
config.color_scheme = "Tokyo Night"

-- fix not being able to write "|" on a mac
-- https://wezfurlong.org/wezterm/config/keyboard-concepts.html?h=mac#macos-left-and-right-option-key
-- NOTE: left option + HJKL is used to control zellij, right option + 7 sends |. This needs to be configured conrrectly in the ergadox EZ layout.

config.send_composed_key_when_left_alt_is_pressed = false

-- integration with nvim and zen-mode
-- https://github.com/folke/zen-mode.nvim?tab=readme-ov-file#wezterm
wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
			overrides.enable_tab_bar = true
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end
	window:set_config_overrides(overrides)
end)

-- and finally, return the configuration to wezterm
return config
