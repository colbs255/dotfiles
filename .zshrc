# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

plugins=(
  git
)

source $ZSH/oh-my-zsh.sh
set -o vi

# Aliases
# GIT
alias gadd="git add --all"
alias gad="git add ."
alias gl="git log"
alias gcm="git commit -m"
alias gcam="git commit -a -m"
alias gcno="git commit --amend --no-edit"
alias gca="git commit --amend"
alias gs="git status"
alias gch="git checkout"
alias gchb="git checkout -b"
alias gri="git rebase -i"
alias grih="git rebase -i HEAD~"
alias gpo="git push origin"
alias gfa="git fetch --all"
alias gio="git init; git remote add origin"

# Other
alias temacs="TERM=xterm-256color emacs -nw"

#Conda
export PATH="/anaconda3/bin:$PATH"
