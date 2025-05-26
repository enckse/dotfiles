#!/usr/bin/env zsh
# =========
export EDITOR=vim
export VISUAL=$EDITOR
export GIT_EDITOR=$EDITOR

[ -e "$HOME/.usrbin" ] && source "$HOME/.usrbin"

export PKGS_STORE="$HOME/.local"
export PKGS_CACHE="$HOME/.cache/pkgversions"
autoload -Uz compinit && compinit
COMPS="${USRBIN_SHARE}/zsh-completion/completions"
if [ -d "$COMPS" ]; then
  for FILE in "$COMPS/"*; do
    . "$FILE"
  done
fi

# =========
export SECRET_ROOT="$HOME/.local/com.ttypty/secrets"
export LOCKBOX_CONFIG_TOML="$SECRET_ROOT/db/config.toml"

# =========
command -v wac > /dev/null && wac motd && wac manage

# =========
bindkey '\e[H' beginning-of-line
bindkey '\e[F' end-of-line

# =========
[ -x "/Applications/MacVim.app/Contents/bin/vim" ] && alias vim="/Applications/MacVim.app/Contents/bin/vim"
command -v bat > /dev/null && alias cat=bat
command -v rg > /dev/null && alias grep="rg"
alias vi="$EDITOR"
[ "$EDITOR" != "vim" ] && alias vim="$EDITOR"
alias less="less -R"

# =========
if command -v delta > /dev/null; then
  export GIT_PAGER=delta
  export DELTA_PAGER="less -R -c -X"
fi
command -v bat > /dev/null && export BAT_OPTS="-pp --theme 'Monokai Extended'"
export GOPATH="$HOME/.cache/go"
zstyle ':completion:*:*:git:*' user-commands uncommitted:'show uncommitted changes'

# =========
cleanup-caches() {
  local dir
  for dir in ".cache/staticcheck" ".cache/gopls" ".cache/go-build" ".cache/vim"; do
    dir="$HOME/$dir"
    [ -d "$dir" ] && find "$dir" -type f -mtime +1 -delete
  done
}

cleanup-caches
unset -f cleanup-caches

# =========
setup-sshagent() {
  local envfile
  envfile="$HOME/.local/state/ssh-agent.env"
  if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > "$envfile"
  fi
  export SSH_AUTH_SOCK="$HOME/.local/state/ssh-agent.socket"
  if [ ! -f "$SSH_AUTH_SOCK" ]; then
    source "$envfile" > /dev/null
  fi
  ssh-add "$HOME/.ssh/"*.privkey >/dev/null 2>&1
}

setup-sshagent
unset -f setup-sshagent

# =========
transcode-media() {
  "$HOME/.local/libexec/transcode-media"
}
pkgv() {
  "$HOME/.local/libexec/pkgv" $@
}

# =========
autoload -U promptinit && promptinit
command -v git-motd >/dev/null && git motd
precmd() {
  GIT_UNCOMMIT=""
  if command -v git-uncommitted >/dev/null; then
      GIT_UNCOMMIT=$(NO_COLOR=1 git uncommitted pwd 2>/dev/null)
      COLORING="%{$(tput setaf 1)%}"
      if [ "$GIT_UNCOMMIT" = "(clean)" ]; then
        COLORING="%{$(tput setaf 2)%}"
      fi
      GIT_UNCOMMIT="$COLORING$GIT_UNCOMMIT"
  fi
  PS1="$GIT_UNCOMMIT%{$(tput setaf 226)%}%n%{$(tput setaf 15)%}@%{$(tput setaf 200)%}%m %{$(tput setaf 45)%}%1~ %{$(tput sgr0)%}$ "
}
