set -gx FZF_DEFAULT_COMMAND 'fd --type f --strip-cwd-prefix'
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -gx FZF_ALT_C_COMMAND 'fd --type d --strip-cwd-prefix'

set -gx FZF_DEFAULT_OPTS "\
--color=bg+:#313244,bg:-1,spinner:#f5e0dc,hl:#32a852 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

fzf --fish | source
