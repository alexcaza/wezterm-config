-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Kanagawa (Gogh)'
config.font_size = 16
config.font = wezterm.font 'CommitMono'
config.keys = {
    {
        key = 'w',
        mods = "CMD",
        action = wezterm.action.CloseCurrentPane {confirm = true}
    },
    {
        key = 'W',
        mods = "CMD",
        action = wezterm.action.CloseCurrentTab {confirm = true}
    },
    {
        key = 'd',
        mods = "CMD",
        action = wezterm.action.SplitHorizontal
    },
    {
        key = 'D',
        mods = "CMD",
        action = wezterm.action.SplitVertical 
    },
}

-- and finally, return the configuration to wezterm
return config
