local wezterm = require("wezterm")

local osToBinPath = {
    linux = "/usr/bin",
    darwin = "/opt/homebrew/bin"
}

local program_path = loadShellPathForOS() .. "/fish"

return {
    default_prog = { program_path, "-l" },
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

function loadShellPathForOS ()
    local handle = io.popen("uname -s | tr '[:upper:]' '[:lower:]'")
    local os_name = string.gsub(handle:read("*a"), "\n", "")
    handle:close()
    return osToBinPath[output]
end
