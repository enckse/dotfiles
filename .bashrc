#!/usr/bin/env bash
source "$HOME/.config/dotfiles/shell"

for FILE in bash.bashrc; do
  echo "$FILE"
  [ -e "/etc/$FILE" ] && . "/etc/$FILE"
done
unset FILE

for DIR in ".cache/staticcheck" \
           ".cache/gopls" \
           ".cache/go-build" \
           ".cache/vim"; do
  DIR="$HOME/$DIR"
  [ -d "$DIR" ] && find "$DIR" -type f -mmin +120 -delete
done


unset DIR

sshagent

export EDITOR=vim
export VISUAL="$EDITOR"
export GIT_EDITOR="$EDITOR"
export GOPATH="$HOME/.cache/go"
[ -d "$GOPATH" ] && export PATH="$GOPATH/bin:$PATH"

loadcomps

alias vi="\$EDITOR"
alias less="less -R"
if command -v bat > /dev/null; then
  alias cat=bat
  export BAT_OPTS="-pp --theme 'Monokai Extended'"
fi
command -v rg > /dev/null && alias grep="rg"
if command -v delta > /dev/null; then
  export GIT_PAGER=delta
  export DELTA_PAGER="less -R -c -X"
fi

uncommitted

USE_HOST="\h"
[ -n "$IS_CONTAINER" ] && USE_HOST="$IS_CONTAINER"
PS1="\u@\[\e[93m\]$USE_HOST\[\e[0m\] \W $ "
command -v git-uncommitted >/dev/null && PS1="\$(git uncommitted pwd 2>/dev/null)$PS1"

unset USE_HOST
shellready
