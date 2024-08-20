set EDITOR nvim
set -gx XDG_CONFIG_HOME $HOME/.config
fish_add_path -g ~/.local/bin

if status is-interactive
    fish_vi_key_bindings
end
