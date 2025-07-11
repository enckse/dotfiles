#!/usr/bin/env bash
source "$HOME/.config/dotfiles/shell"

if command -v sway > /dev/null && [ "$(tty)" = "/dev/tty1" ]; then
  export XDG_SESSION_TYPE=wayland
  export XDG_SESSION_DESKTOP=sway
  export XDG_CURRENT_DESKTOP=sway
  export MOZ_ENABLE_WAYLAND=1
  update-desktop-entries
  mkdir -p "$HOME/.config/rc/runlevels/gui"
  exec dbus-run-session sway > "$HOME/.cache/sway.log" 2>&1
fi

cleancaches
sshagent
loadcomps

USE_HOST="\h"
[ -n "$IS_CONTAINER" ] && USE_HOST="$IS_CONTAINER"
PS1="\u@\[\e[93m\]$USE_HOST\[\e[0m\] \W $ "

unset USE_HOST
shellready
