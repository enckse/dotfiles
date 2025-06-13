#!/usr/bin/env zsh
# =========
export EDITOR=vim
[ -e "$HOME/.config/dotfiles/editor" ] && DOTFILES_EDITOR=$(cat "$HOME/.config/dotfiles/editor") && EDITOR="$DOTFILES_EDITOR" && export DOTFILES_EDITOR EDITOR
export VISUAL=$EDITOR
export GIT_EDITOR=$EDITOR
export GOPATH="$HOME/.cache/go"
export PKGV_STORE="$HOME/.local/pkgv"

# =========
autoload -Uz compinit && compinit
[ -e "$PKGV_STORE/env" ] && source "$PKGV_STORE/env"

# =========
export SECRET_ROOT="$HOME/.ttypty/secrets"
export LOCKBOX_CONFIG_TOML="$SECRET_ROOT/config.toml"

# =========
command -v wac > /dev/null && wac motd && wac manage

# =========
bindkey '\e[H' beginning-of-line
bindkey '\e[F' end-of-line

# =========
[ -x "/Applications/MacVim.app/Contents/bin/vim" ] && alias vim="/Applications/MacVim.app/Contents/bin/vim"
[ "$EDITOR" != "vim" ] && alias vim="$EDITOR"
alias vi="$EDITOR"

# =========
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
command -v git-uncommitted > /dev/null && zstyle ':completion:*:*:git:*' user-commands uncommitted:'show uncommitted changes'

# =========
cleanup-caches() {
  local dir
  for dir in ".cache/staticcheck" \
             ".cache/gopls" \
             ".cache/go-build" \
             ".cache/vim" \
             ".local/state/nvim/swap" \
             ".local/state/nvim/undo"; do
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
