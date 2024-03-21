local wezterm = require 'wezterm'
local config = {}

config.color_scheme = 'Gruvbox dark, soft (base16)'
config.window_background_opacity = 0.95
config.window_decorations = "RESIZE"
config.enable_tab_bar = false
config.font = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Bold' })

return config
