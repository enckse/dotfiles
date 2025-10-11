#!/bin/sh

# <xbar.title>Release Check</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.desc>Displays release checks</xbar.desc>
#
# Dependencies: none.

LOCKER="$HOME/.local/bin/is-screen-locked"
[ ! -x "$LOCKER" ] && exit 0
! "$LOCKER" && exit 0

BIN="$HOME/.local/bin/relchk"
if [ ! -x "$BIN" ]; then
  echo " ∅ relchk"
  exit 0
fi
"$HOME/.local/bin/relchk" bar
