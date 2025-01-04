-- pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration
local config = wezterm.config_builder()

config.font = wezterm.font("Hack Nerd Font Mono")
config.font_size = 14

config.color_scheme = 'Catppuccin Macchiato (Gogh)'

config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.window_close_confirmation = 'NeverPrompt'

config.window_background_opacity = 0.8
config.macos_window_background_blur = 10

config.front_end = "OpenGL"
config.max_fps = 144
config.default_cursor_style = "BlinkingBlock"
config.animation_fps = 1
config.cursor_blink_rate = 500
config.prefer_egl = true

-- -------- WINDOWS SPECIFIC SETTINGS --------
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    
    -- LEGACY use powershell (for win 11 i think its 'pwsh.exe')
    -- config.default_prog = { 'powershell.exe' }
    
    -- Use Git Bash
    config.default_prog = { 'C:/Program Files/Git/bin/bash.exe', '--login' }
    
    -- wasnt working for me
    -- Possible values = Auto | Disable | Acrylic | Mica | Tabbed
    -- config.win32_system_backdrop = 'Acrylic'
    
end
    
-- Keep adding configuration options here
-- 

return config
