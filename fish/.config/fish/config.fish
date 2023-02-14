eval "$(/opt/homebrew/bin/brew shellenv)"
set EDITOR nvim

if status is-interactive
    fish_vi_key_bindings
end

function fish_prompt
    set_color green
    echo (pwd)
    echo '> '
end
