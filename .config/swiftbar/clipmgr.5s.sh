#!/bin/sh

# <xbar.title>WAC Info</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.desc>Displays wac info</xbar.desc>
#
# Dependencies: none.

LOCKER="$HOME/.local/bin/is-screen-locked"
[ ! -x "$LOCKER" ] && exit 0
! "$LOCKER" && exit 0

ICON="📋"
LOGS="$("$HOME/.local/bin/clipmgr" logs)"
printf "%s\n" "$ICON"
echo "---"
echo "$LOGS"
