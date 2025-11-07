#!/usr/bin/env zsh
export XDG_CACHE_HOME="$HOME/Library/Caches"
source "$HOME/.config/ttypty/shell"
bindkey '\e[H' beginning-of-line
bindkey '\e[F' end-of-line

ssh_agent

if [ -d /opt/homebrew ]; then
  export HOMEBREW_PREFIX="/opt/homebrew";
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
  export HOMEBREW_REPOSITORY="/opt/homebrew";
  fpath[1,0]="/opt/homebrew/share/zsh/site-functions";
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  [ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}";
  export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
  for BIN in findutils coreutils diffutils make gnu-sed; do
    DIR="/opt/homebrew/opt/$BIN"
    [ -d "$DIR" ] && PATH="$DIR/libexec/gnubin:$PATH"
  done
  export PATH="/opt/homebrew/bin:$PATH"
else
  for CMD in vim vi git; do
    alias $CMD="echo $CMD disabled"
  done
  quickfix() {
    /usr/bin/vim --clean $@
  }
fi

command -v container > /dev/null && alias alpine="container run -it --rm --mount type=bind,source='$HOME/Downloads',target=/opt alpine /bin/ash"
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

shell_ready
command -v git-uncommitted >/dev/null && git-uncommitted
