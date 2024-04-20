set EDITOR nvim
set -gx TERM screen-256color
set -gx XDG_CONFIG_HOME $HOME/.config

if status is-interactive
    fish_vi_key_bindings
end

function fish_prompt
    set_color green
    echo (pwd)
    echo '➜ '
end

function fish_greeting
    set_color blue
    echo Welcome $USER!
end
