-- pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration
local config = wezterm.config_builder()

config.font = wezterm.font("Hack Nerd Font Mono")
config.font_size = 18

config.color_scheme = 'Catppuccin Macchiato (Gogh)'

config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.window_close_confirmation = 'NeverPrompt'

config.window_background_opacity = 0.8
config.macos_window_background_blur = 10

-- -------- WINDOWS SPECIFIC SETTINGS --------

-- LEGACY use powershell (for win 11 i think its 'pwsh.exe')
-- config.default_prog = { 'powershell.exe' }

-- Use Git Bash
config.default_prog = { 'C:/Program Files/Git/bin/bash.exe', '--login' }

-- Keep adding configuration options here
-- 

return config
