#!/bin/sh -e
VERSION=0.0.33
FILE="$PKGS_WD/$VERSION.filen"
[ "$OS" = "darwin" ] && HASH="ff5af62"

download-and-check \
  -u "https://github.com/FilenCloudDienste/filen-cli/releases/download/v$VERSION/filen-cli-v$VERSION-$OS_ALT-$PKGS_ALTARCH" \
  -f "$FILE" \
  -d "executable" \
  -h "$HASH"

install -Dm755 "$FILE" "$PKGS_BIN/filen"
