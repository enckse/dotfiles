#!/bin/sh

# <xbar.title>Status Info</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.desc>Displays status changes</xbar.desc>
#
# Dependencies: none.

LOCKER="$HOME/.local/bin/is-screen-locked"
[ ! -x "$LOCKER" ] && exit 0
! "$LOCKER" && exit 0

ERRORED=0
for CMD in git-uncommitted reltracker; do
  SUB="check"
  [ "$CMD" = "git-uncommitted" ] && SUB="list"
  BIN="$HOME/.local/bin/$CMD"
  if [ -x "$BIN" ]; then
    TEXT=$($BIN $SUB)
    [ -z "$TEXT" ] && continue
    if [ "$ERRORED" -eq 0 ]; then
      echo "🚨"
      echo "---"
      ERRORED=1
    fi
    echo "$CMD"
    echo "$TEXT" | sed 's/^/- /g'
  fi
done
  
[ "$ERRORED" -eq 1 ] && exit 0
echo "✅"
