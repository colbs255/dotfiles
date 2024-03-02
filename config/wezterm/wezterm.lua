local wezterm = require("wezterm")

return {
    font = wezterm.font("JetBrains Mono"),
    font_size = 18.0,
    color_scheme = "Catppuccin Mocha",
    hide_tab_bar_if_only_one_tab = true,
    cursor_blink_rate = 800,
    window_close_confirmation = "NeverPrompt",
    window_background_opacity = 0.9,
    scrollback_lines = 50000,
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
    window_decorations = "RESIZE",
}
