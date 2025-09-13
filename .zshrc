#!/usr/bin/env zsh
SIMPLE_TERM=1
USING_CODE=0
autoload -Uz compinit && compinit
[ -d "/Applications/VSCodium.app" ] && export EDITOR="/Applications/VSCodium.app/Contents/Resources/app/bin/codium"
[ -n "$EDITOR" ] && SIMPLE_TERM=0 && USING_CODE=1 && alias code="$EDITOR"
source "$HOME/.config/dotfiles/shell"
bindkey '\e[H' beginning-of-line
bindkey '\e[F' end-of-line

ssh_agent
load_comps

if command -v devtools > /dev/null; then
  export TOOLS_IDENTIFIER=$(date +%Y-%U)
  devtools
fi

if [ "$SIMPLE_TERM" -eq 1 ]; then
  if ! command -v brew > /dev/null; then
    for CMD in vim vi; do
        alias $CMD="echo $CMD disabled"
    done
    quickfix() {
        /usr/bin/vim --clean $@
    }
  fi
else
  alias vim="$EDITOR"
  alias vi="$EDITOR"
  [ "$USING_CODE" -eq 1 ] && export GIT_EDITOR="$EDITOR --wait"
fi
unset SIMPLE_TERM USING_CODE

command -v devcontainer > /dev/null && (devcontainer orphans >/dev/null 2>&1 &)

if command -v brew > /dev/null; then
  eval "$(brew shellenv)"
  for BIN in "make/libexec/gnubin" "curl/bin"; do
    LIBEXEC="/opt/homebrew/opt/$BIN"
    [ -d "$LIBEXEC" ] && PATH="$LIBEXEC:$PATH"
  done
  unset BIN LIBEXEC
fi	

autoload -U promptinit && promptinit
precmd() {
  GIT_UNCOMMIT=""
  if command -v git-uncommitted >/dev/null; then
      GIT_UNCOMMIT=$(NO_COLOR=1 git-uncommitted pwd 2>/dev/null)
      COLORING="%{$(tput setaf 1)%}"
      if [ "$GIT_UNCOMMIT" = "(clean)" ]; then
        COLORING="%{$(tput setaf 2)%}"
      fi
      GIT_UNCOMMIT="$COLORING$GIT_UNCOMMIT"
  fi
  PS1="$GIT_UNCOMMIT%{$(tput setaf 226)%}%n%{$(tput setaf 15)%}@%{$(tput setaf 200)%}%m %{$(tput setaf 45)%}%1~ %{$(tput sgr0)%}$ "
}

shell_ready
command -v git-uncommitted >/dev/null && git-uncommitted
