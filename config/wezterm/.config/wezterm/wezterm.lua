local wezterm = require("wezterm")

local osToBinPath = {
    linux = { "/usr/bin/toolbox", "run", "-c", "main", "fish", "-l" },
    darwin = { "/opt/homebrew/bin/fish", "-l" }
}

local function loadLaunchProgramArgs ()
    local handle = io.popen("uname -s | tr '[:upper:]' '[:lower:]'")
    local osName = string.gsub(handle:read("*a"), "\n", "")
    handle:close()
    return osToBinPath[osName]
end

return {
    default_prog = loadLaunchProgramArgs(),
    font = wezterm.font("JetBrains Mono"),
    font_size = 18.0,
    color_scheme = "Catppuccin Mocha",
    hide_tab_bar_if_only_one_tab = true,
    cursor_blink_rate = 800,
    window_close_confirmation = "NeverPrompt",
    window_background_opacity = 0.9,
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
}
