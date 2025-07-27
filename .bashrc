#!/usr/bin/env bash
source "$HOME/.config/dotfiles/shell"

ssh_agent
load_comps
command -v devtools >/dev/null && devtools

USE_HOST="\h"
[ -n "$IS_CONTAINER" ] && USE_HOST="$IS_CONTAINER"
PS1="\u@\[\e[93m\]$USE_HOST\[\e[0m\] \W $ "

unset USE_HOST
shell_ready
