# os specific
switch (uname)
    case Linux
    case Darwin
        eval "$(/opt/homebrew/bin/brew shellenv)"
end

set EDITOR nvim
set -gx TERM screen-256color

if status is-interactive
    fish_vi_key_bindings
end

function fish_prompt
    set_color green
    echo (pwd)
    echo '> '
end

function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end

abbr --add dotdot --regex '^\.\.+$' --function multicd
abbr --add lg lazygit
abbr --add vi nvim
