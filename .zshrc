#!/usr/bin/env zsh
export XDG_CACHE_HOME="$HOME/Library/Caches"
bindkey '\e[H' beginning-of-line
bindkey '\e[F' end-of-line

if command -v brew > /dev/null; then
  eval "$(brew shellenv)"
  for item in gnu-sed make findutils; do
    [ -d "/opt/homebrew/opt/$item/libexec/gnubin" ] && PATH="/opt/homebrew/opt/$item/libexec/gnubin:$PATH"
  done
else
  for CMD in vim git; do
    alias "$CMD"="echo no $CMD"
  done
  unset CMD
  alias quickfix="/usr/bin/vim"
fi

source "$HOME/.config/ttypty/shell"
ssh_agent

if command -v devcontainer > /dev/null; then
  [ -e "$HOME/.config/devcontainer/env.sh" ] && . "$HOME/.config/devcontainer/env.sh"
else
  for ENGINE in container podman; do
    command -v "$ENGINE" > /dev/null && export CONTAINER_ENGINE="$ENGINE" && alias alpine="$ENGINE run -it --rm --mount type=bind,source='$HOME/Downloads',target=/opt alpine /bin/ash" && break
  done
  unset ENGINE
fi

command -v devtools > /dev/null && devtools
autoload -Uz compinit && compinit
load_comps
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
  IS_VENV=""
  [ -n "$VIRTUAL_ENV" ] && IS_VENV="[venv]"
  PS1="$GIT_UNCOMMIT%{$(tput setaf 226)%}%n%{$(tput setaf 15)%}@%{$(tput setaf 200)%}%m %{$(tput setaf 45)%}%1~ %{$(tput sgr0)%}$IS_VENV$ "
}

post_setup
shell_ready
command -v git-uncommitted >/dev/null && git-uncommitted
