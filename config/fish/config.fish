set EDITOR nvim
set -gx TERM screen-256color
set -gx XDG_CONFIG_HOME $HOME/.config

if status is-interactive
    fish_vi_key_bindings
end

# Prompt
function fish_prompt
    set_color green
    echo (pwd)
    echo '➜ '
end

function fish_greeting
    set_color blue
    echo Welcome $USER!
end

# Abbreviations
abbr --add lg lazygit
abbr --add vi nvim
function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr --add dotdot --regex '^\.\.+$' --function multicd
abbr --add x 'cd "$(xplr --print-pwd-as-result)"'
abbr --add c 'bat --style=plain --paging=never'
abbr --add ls 'exa -F --icons --group-directories-first'
abbr --add homeupdate 'home-manager --extra-experimental-features nix-command --extra-experimental-features flakes switch --flake ~/dotfiles/config'

# Setup paths
fish_add_path ~/.cabal/
fish_add_path ~/.ghcup/bin/
zoxide init fish | source
