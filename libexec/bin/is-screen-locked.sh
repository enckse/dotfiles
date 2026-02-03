#!/bin/sh
[ $(uname) != "Darwin" ] && echo "script not configured for this os" && exit 1
if [ "$(/usr/libexec/PlistBuddy -c "print :IOConsoleUsers:0:CGSSessionScreenIsLocked" /dev/stdin 2>/dev/null <<< "$(ioreg -n Root -d1 -a)")" = "true" ]; then
  # locked
  exit 1
else
  # unlocked
  exit 0
fi
