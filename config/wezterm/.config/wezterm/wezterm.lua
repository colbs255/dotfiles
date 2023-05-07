local wezterm = require("wezterm")

return {
    default_prog = { "/usr/bin/fish", "-l" },
    font = wezterm.font("JetBrains Mono"),
    font_size = 18.0,
    color_scheme = "Catppuccin Mocha",
    hide_tab_bar_if_only_one_tab = true,
    cursor_blink_rate = 800,
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
}
