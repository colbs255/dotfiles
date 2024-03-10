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
abbr --add c 'bat --style=plain --paging=never'
abbr --add ls 'exa -F --icons --group-directories-first'
abbr --add homebuild 'home-manager --extra-experimental-features nix-command --extra-experimental-features flakes switch --flake ~/dotfiles/config'
abbr --add sysbuild 'sudo nixos-rebuild switch --flake ~/dotfiles/config'

function yazi_cd
	set tmp (mktemp -t "yazi-cwd.XXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		cd -- "$cwd"
	end
	rm -f -- "$tmp"
end
abbr --add ya yazi_cd

# Setup paths
zoxide init fish | source
