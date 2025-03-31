#!/usr/bin/env zsh
# =========
export EDITOR=vim
export VISUAL=$EDITOR
export GIT_EDITOR=$EDITOR

# =========
export PKGS_MOUNT="/Volumes/Tools"
export PKGS_SHARE="PKGS_MOUNT/share/"
export PKGS_STORE="$HOME/.cache/pkgversions"
VOLS="$PKGS_STORE/disks/"
if [ -d "$VOLS" ] && [ ! -d "$PKGS_MOUNT" ]; then
  VOLS="$VOLS"$(ls "$VOLS" | sort -r | head -n 1)
  hdiutil attach -readonly "$VOLS"
fi
[ -d "$PKGS_MOUNT" ] && path=("$PKGS_MOUNT/bin" $path)

# =========
autoload -Uz compinit && compinit
COMPS="$TOOLS/share/zsh-completion/completions"
if [ -d "$COMPS" ]; then
  for FILE in "$COMPS/"*; do
    source "$FILE"
  done
fi

# =========
command -v bat > /dev/null && alias cat=bat
command -v rg > /dev/null && alias grep="rg"
alias vi="$EDITOR"
alias vim="$EDITOR"
alias less="less -R"
alias vim="/Applications/MacVim.app/Contents/bin/vim"

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
export SECRET_ROOT="$HOME/Library/com.ttypty/secrets"
export LOCKBOX_CONFIG_TOML="$SECRET_ROOT/configs/darwin.toml"

# =========
transcode-media() {
  "$HOME/.local/libexec/transcode-media"
}

# =========
autoload -U promptinit && promptinit
command -v git-motd >/dev/null && git motd
precmd() {
  GIT_UNCOMMIT=""
  if command -v git-uncommitted >/dev/null; then
      GIT_UNCOMMIT=$(git uncommitted pwd 2>/dev/null)
  fi
  PS1="$GIT_UNCOMMIT%{$(tput setaf 226)%}%n%{$(tput setaf 15)%}@%{$(tput setaf 10)%}%m %{$(tput setaf 33)%}%1~ %{$(tput sgr0)%}$ "
}
