#!/usr/bin/env bash
source "$HOME/.config/dotfiles/shell"

cleancaches
sshagent
loadcomps
uncommitted

USE_HOST="\h"
[ -n "$IS_CONTAINER" ] && USE_HOST="$IS_CONTAINER"
PS1="\u@\[\e[93m\]$USE_HOST\[\e[0m\] \W $ "
command -v git-uncommitted >/dev/null && PS1="\$(git uncommitted pwd 2>/dev/null)$PS1"

unset USE_HOST
shellready
