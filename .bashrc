#!/usr/bin/env bash
[[ $- != *i* ]] && return

source /etc/bash.bashrc

shopt -s direxpand

export VISUAL=vi
export VISUAL=nvim
export DELTA_PAGER="less -c -X"

export EDITOR="$VISUAL"
export COMP_KNOWN_HOSTS_WITH_HOSTFILE=""
export TERM=xterm-256color
export PATH="$HOME/.local/bin:$PATH"
export GOPATH="$HOME/.cache/go"
export GOFLAGS="-ldflags=-linkmode=external -trimpath -buildmode=pie -mod=readonly -modcacherw -buildvcs=false"

# disable ctrl+s
stty -ixon

# cache cleanups
file="$HOME/.local/state/nvim/undo"
if [ -d "$file" ]; then
  find "$file" -type f -mmin +60 -delete
fi

# check the window size after each command
shopt -s checkwinsize

PS1="\u@\h:\W -> "
SSH_AGENT_ENV="$HOME/.local/state/ssh-agent.env"
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
  ssh-agent > "$SSH_AGENT_ENV"
fi
export SSH_AUTH_SOCK="$HOME/.local/state/ssh-agent.socket"
if [[ ! -f "$SSH_AUTH_SOCK" ]]; then
  source "$SSH_AGENT_ENV" >/dev/null
fi
for file in "$HOME/.ssh/"*.key; do
  ssh-add "$file" > /dev/null 2>&1
done

PS1="\$(git uncommitted --pwd 2>/dev/null)$PS1"

unset file

source "$HOME/.bash_aliases"

lb resync
git uncommitted
