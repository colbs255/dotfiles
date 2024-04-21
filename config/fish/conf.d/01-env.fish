set EDITOR nvim
set -gx TERM screen-256color
set -gx XDG_CONFIG_HOME $HOME/.config

if status is-interactive
    fish_vi_key_bindings
end

function fish_prompt
    set_color green
    prompt_pwd --full-length-dirs=100 --dir-length=100
    echo '➜ '
end

function fish_greeting
    set_color blue
    echo Welcome $USER!
end

function fish_command_not_found
    echo Command not found: (set_color red)$argv[1]
end
