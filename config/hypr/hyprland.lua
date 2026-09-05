-- Hyprland config
-- Since Hyprland 0.55, hyprlang (hyprland.conf) is deprecated in favor of Lua.
-- See https://wiki.hypr.land/Configuring/Start/

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "auto",
})

---------------------
---- MY PROGRAMS ----
---------------------

local terminal = "foot fish"
local browser = "firefox"
local fileManager = "dolphin"
local menu = "fuzzel"
local claudeTerm = "foot -o colors-dark.alpha=1.0 --app-id=claude-floating fish -c 'mkdir -p ~/scratch; cd ~/scratch; claude --dangerously-skip-permissions'"

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
    hl.exec_cmd("swaybg -i ~/.config/wallpapers/desktop")
    hl.exec_cmd("waybar")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct") -- change to qt6ct if you have that

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- See https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in = 10,
        gaps_out = 20,
        border_size = 2,

        col = {
            active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        layout = "dwindle",

        -- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,
    },

    decoration = {
        rounding = 10,

        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },

        shadow = {
            enabled = false,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Some default animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- you probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = -1, -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = true,
    },
})

---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "ctrl:nocaps",
        kb_rules = "",

        repeat_delay = 240,
        repeat_rate = 80,

        follow_mouse = 1,

        sensitivity = 0.3, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})

-----------------
---- SCRIPTS ----
-----------------

local googleSearchCmd = [[
choice=$(fuzzel --prompt "G: " --lines 0 --dmenu <<< '')
[ -z "$choice" ] && exit 0
xdg-open "https://www.google.com/search?q=$choice"
]]

local logoutMenuCmd = [[
choice=$(printf '%s\n' " Lock" " Shutdown" "󰍃 Logout" " Reboot" | fuzzel --hide-prompt --lines 4 --dmenu --index)
case "$choice" in
    0) hyprlock ;;
    1) systemctl poweroff ;;
    2) hyprctl dispatch exit ;;
    3) systemctl reboot ;;
esac
]]

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

-- See https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + return", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + grave", hl.dsp.exec_cmd(claudeTerm))
hl.bind(mainMod .. " + SHIFT + escape", hl.dsp.exec_cmd(logoutMenuCmd))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + space", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + SHIFT + space", hl.dsp.exec_cmd(googleSearchCmd))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu --with-nth 2 | cliphist decode | wl-copy"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + T", hl.dsp.group.toggle())
hl.bind(mainMod .. " + tab", hl.dsp.group.next())
hl.bind(mainMod .. " + SHIFT + tab", hl.dsp.group.prev())

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/ for more
hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    name = "claude-floating-terminal",
    match = { class = "^claude-floating$" },

    float = true,
    size = "(monitor_w*0.6) (monitor_h*0.6)",
    center = true,
})
