#!/usr/bin/env bash

choice=$(fuzzel --prompt "G: " --lines 0 --dmenu <<< '')

if [ -z "$choice" ]; then
    echo "The string is empty."
fi

search_url="https://www.google.com/search?q="
xdg-open "$search_url""$choice"
