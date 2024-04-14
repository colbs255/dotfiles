#!/usr/bin/env bash

choice=$(fuzzel --prompt "G: " --lines 0 --dmenu <<< '')

if [ -z "$choice" ]; then
    exit
fi

search_url="https://www.google.com/search?q="
xdg-open "$search_url$choice"
