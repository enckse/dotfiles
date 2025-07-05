#!/bin/sh

# <xbar.title>Git Info</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.desc>Displays git changes</xbar.desc>
#
# Dependencies: none.

BIN="$HOME/.local/bin/git-uncommitted"
if [ ! -x "$BIN" ]; then
  echo " ∅ git"
  exit 0
fi
"$HOME/.local/bin/git-uncommitted"
