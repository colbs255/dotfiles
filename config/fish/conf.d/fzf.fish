set -gx FZF_DEFAULT_COMMAND 'fd --type f --strip-cwd-prefix'
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -gx FZF_ALT_C_COMMAND 'fd --type d --strip-cwd-prefix'
fzf --fish | source
