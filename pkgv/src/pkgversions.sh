#!/bin/sh -e
CACHE="$HOME/.cache/pkgversions"
mkdir -p "$CACHE"
RUN="$CACHE/run"
FORCE=0
RAN=0

while getopts "f" opt ; do
  case $opt in
    f) FORCE=1;;
    *)
      echo "unknown arg $opt"
      exit 1
      ;;
  esac
done

if [ "$FORCE" -eq 0 ] && [ -e "$RUN" ]; then
  if [ "$(find "$RUN" -type f -mmin -60 | wc -l)" -gt 0 ]; then
    echo "recent update check completed..."
    exit 0
  fi
fi

_store() {
  name=$(echo "$1" | tr -cd "[:alnum:]._-")
  vers=$(echo "$2" | tr -cd "[:alnum:]._-")
  hashed="$(echo "$1 -> $2" | sha256sum | cut -c 1-7)"
  file="$CACHE/$name.$vers.$hashed"
  if [ -e "$file" ]; then
    return
  fi
  echo "$1 -> $2"
  printf "  processed? (y/N) "
  read yesno
  case "$yesno" in
    "Y" | "y")
      echo "$1 $2" > "$file"
      return
      ;;
  esac
  RAN=1
}

_header() {
  echo "processing: $1" >&2
}

_version() {
  _header "$1"
  git-feed -url "$1" | grep -E "$2"
}

check_version() {
  FOUND=0
  BASE=$(basename "$1")
  for vers in $(_version "$1" "$2"); do
    FOUND=1
    _store "$BASE" "$vers"
  done
  if [ "$FOUND" -eq 0 ]; then
    if [ -z "$2" ]; then
      echo "no versions found"
      exit 1
    fi
  fi
}

for FILE in "$PKGV_STORE/" "$HOME/.config/pkgversions/"; do
  FILE="${FILE}pkglist"
  [ ! -e "$FILE" ] && echo "$FILE does not exist" && continue
  echo "config: $FILE" >&2
  source "$FILE"
done
[ "$RAN" -eq 0 ] && touch "$RUN"
