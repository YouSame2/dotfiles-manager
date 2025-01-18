-- pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration
local config = wezterm.config_builder()

config.font = wezterm.font("Hack Nerd Font Mono")
config.font_size = 14

config.color_scheme = 'Tokyo Night'

config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.window_close_confirmation = 'NeverPrompt'
config.adjust_window_size_when_changing_font_size = false
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true

config.window_background_opacity = 0.95
config.macos_window_background_blur = 10

config.front_end = "WebGpu" -- breaks transparency on win
config.webgpu_power_preference = "HighPerformance"
config.max_fps = 60
config.default_cursor_style = "BlinkingBlock"
config.animation_fps = 60
config.cursor_blink_rate = 500

---------- KEYBINDINGS --------
config.keys = {
    -- Default QuickSelect keybind (CTRL-SHIFT-Space) gets captured by something else on my system
    {
      key = 'A',
      mods = 'CTRL|SHIFT',
      action = wezterm.action.QuickSelect,
    },
  }

---------- WINDOWS SPECIFIC SETTINGS --------
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    
    -- LEGACY use powershell (for win 11 i think its 'pwsh.exe')
    -- config.default_prog = { 'powershell.exe' }
    
    -- Use Git Bash
    config.front_end = "OpenGL"
    config.default_prog = { 'C:/Program Files/Git/bin/bash.exe', '--login' }
    config.max_fps = 144
    config.animation_fps = 144
    
    -- wasnt working for me
    -- Possible values = Auto | Disable | Acrylic | Mica | Tabbed
    -- config.win32_system_backdrop = 'Acrylic'
    
end
return config

---------- CREDIT AND RESOURCES --------
-- https://github.com/mplusp/dotfiles/tree/main
-- OTHER GOOD THEMES: Tokyo Night, Catppuccin Macchiato (Gogh)