#!/bin/sh

# <xbar.title>WAC Info</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.desc>Displays wac info</xbar.desc>
#
# Dependencies: none.

LOCKER="$HOME/.local/bin/is-screen-locked"
[ ! -x "$LOCKER" ] && exit 0
! "$LOCKER" && exit 0

_notavailable() {
  echo " ∅ wac"
  exit 0
}

ENV="$HOME/.config/dotfiles/shell"
if [ ! -e "$ENV" ]; then
  _notavailable
fi
. "$ENV"
if command -v wac > /dev/null; then
  MESSAGE=$(wac service)
  DONE=$(wac "done")
  if [ "$DONE" = "true" ]; then
    if [ -z "$MESSAGE" ]; then
      printf " ●\n---\n"
    else
      printf " ⊖︎\n---\n"
    fi
  else
    printf " ○\n---\n"
  fi
  if [ -n "$MESSAGE" ]; then
    echo "$MESSAGE"
  else
    echo
  fi
else
  _notavailable
fi
