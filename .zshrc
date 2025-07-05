#!/usr/bin/env zsh
autoload -Uz compinit && compinit
source "$HOME/.config/dotfiles/shell"
bindkey '\e[H' beginning-of-line
bindkey '\e[F' end-of-line

cleancaches
sshagent
loadcomps

for CMD in git vim vi; do
    alias $CMD="echo $CMD disabled"
done
quickfix() {
    /usr/bin/vim --clean $@
}

if command -v wac > /dev/null; then
  motd wac service
else
  motdheader wac
  echo "-> unavailable"
  echo
fi

command -v devcontainer > /dev/null && (devcontainer orphans >/dev/null 2>&1 &)
command -v clipmgr > /dev/null && clipmgr

uncommitted

command -v git-uncommitted >/dev/null &&zstyle ':completion:*:*:git:*' user-commands uncommitted:'show uncommitted changes'
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

shellready
