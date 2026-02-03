#!/bin/sh -e
CACHEDIR="$HOME/.local/state/devtools"
CONFIGS="$HOME/.config/ttypty/"
mkdir -p "$CACHEDIR"
FORCE=0
if [ -n "$1" ]; then
  [ "$1" != "force" ] && echo "unknown argument: $1" && exit 1
  FORCE=1
fi
find "$CACHEDIR" -type f -mtime +7 -delete
for FILE in "$CONFIGS"*devtools.sh; do 
  NAME=$(basename "$FILE" | cut -d "." -f 1)
  CACHEFILE="$CACHEDIR/$NAME.$(date +%U)"
  [ "$FORCE" -eq 0 ] && [ -e "$CACHEFILE" ] && touch "$CACHEFILE" && continue
  "$FILE"
  touch "$CACHEFILE"
done
