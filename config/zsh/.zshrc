# zsh stays the login shell; interactive Rex terminals hand off to fish.
if [[ -o interactive && $TERM_PROGRAM == rex ]] && command -v fish >/dev/null; then
  exec fish
fi
