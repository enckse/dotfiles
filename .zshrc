#!/usr/bin/env zsh
source "$HOME/.config/dotfiles/shell"
autoload -Uz compinit && compinit
bindkey '\e[H' beginning-of-line
bindkey '\e[F' end-of-line

ssh_agent
load_comps

for CMD in vim vi git; do
    alias $CMD="echo $CMD disabled"
done
quickfix() {
    /usr/bin/vim --clean $@
}

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
