#!/usr/bin/env bash

# Fuzzel expects choices to be separated by newlines
declare -a choices=(
    [0]=" Lock"
    [1]=" Shutdown"
    [2]="󰍃 Logout"
    [3]=" Reboot"
)
choice_str=$(printf "%s\n" "${choices[@]}")

# User picks a choice with fuzzel
choice=$(fuzzel --prompt "❯ " --lines 4 --dmenu --index <<< "$choice_str")

case $choice in
    0)
        hyprlock
        ;;
    1)
        systemctl poweroff
        ;;
    2)
        hyprctl dispatch exit
        ;;
    3)
        systemctl reboot
        ;;
    *)
        ;;
esac
