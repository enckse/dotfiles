#!/usr/bin/env bash
source "$HOME/.config/ttypty/shell"

ssh_agent
load_comps
command -v devtools >/dev/null && devtools

USE_HOST="\h"
[ -n "$CONTAINER_NAME" ] && USE_HOST="$CONTAINER_NAME"
PS1="\u@\[\e[93m\]$USE_HOST\[\e[0m\] \W $ "
command -v git-uncommitted >/dev/null && PS1="\$(git uncommitted pwd 2>/dev/null)$PS1"

unset USE_HOST
shell_ready
command -v git-uncommitted >/dev/null && git-uncommitted
