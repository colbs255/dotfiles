# Auto start Hyprland on tty1
if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec start-hyprland &> /dev/null
fi
