#!/usr/bin/env bash

# Fuzzel expects choices to be separated by newlines
choices=" Lock
󰍃 Logout
 Shutdown
 Reboot"

# User picks a choice with fuzzel
choice=$(fuzzel --prompt "❯ " --lines 4 --dmenu <<< "$choices")
choice_without_icon=${choice:2}

case $choice_without_icon in
    "Lock")
        hyprlock
        ;;
    "Logout")
        hyprctl dispatch exit
        ;;
    "Shutdown")
        systemctl poweroff
        ;;
    "Reboot")
        systemctl reboot
        ;;
    *)
        ;;
esac
