#!/usr/bin/env bash
source "$HOME/.config/dotfiles/shell"
[ -e "$HOME/.bash.vars" ] && source "$HOME/.bash.vars"

ssh_agent
load_comps
command -v devtools >/dev/null && devtools

USE_HOST="\h"
[ -n "$IS_CONTAINER" ] && USE_HOST="$IS_CONTAINER"
PS1="\u@\[\e[93m\]$USE_HOST\[\e[0m\] \W $ "
command -v git-uncommitted >/dev/null && PS1="\$(git uncommitted pwd 2>/dev/null)$PS1"

unset USE_HOST
shell_ready
command -v git-uncommitted >/dev/null && git-uncommitted
