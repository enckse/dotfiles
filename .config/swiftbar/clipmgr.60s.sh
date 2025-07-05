#!/bin/sh

# <xbar.title>Clipboard Manager</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.desc>Manages clipboard</xbar.desc>
#
# Dependencies: none.

CONTENT=$(pbpaste)
CACHE="$HOME/.cache/clipmgr"
mkdir -p "$CACHE"
find "$CACHE" -type f -mtime +3 -delete
LOG="$CACHE/$(date +%Y-%m-%d).log"
printf " 📋\n---\n"
date
[ -e "$LOG" ] && tail -n 10 "$LOG"
if [ -z "$CONTENT" ]; then
  exit 0
fi

CONTENT=$(pbpaste | sha256sum | cut -c 1-7)

{
  date
  echo "initialized"
  COUNT=0
  while [ "$COUNT" -lt 45 ]; do
    PASTE=$(pbpaste)
    [ -z "$PASTE" ] && echo "cleared..." && break
    PASTE=$(pbpaste | sha256sum | cut -c 1-7)
    [ "$CONTENT" != "$PASTE" ] && echo "changed..." && break
    sleep 1
    COUNT=$((COUNT+1))
  done
  echo "clearing"
  printf "" | pbcopy
  echo "exiting"
  date
} >> "$LOG" 2>&1
