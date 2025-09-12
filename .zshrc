#!/usr/bin/env zsh
autoload -Uz compinit && compinit
source "$HOME/.config/dotfiles/shell"
bindkey '\e[H' beginning-of-line
bindkey '\e[F' end-of-line

ssh_agent
load_comps

if command -v devtools > /dev/null; then
  export TOOLS_IDENTIFIER=$(date +%Y-%m-%d)
  devtools
fi

for CMD in vim vi; do
    alias $CMD="echo $CMD disabled"
done
quickfix() {
    /usr/bin/vim --clean $@
}

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
