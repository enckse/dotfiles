#!/bin/sh -e
VERSION=0.25.0
FILE="$PKGS_WD/$VERSION.bat.tar.gz"
[ "$OS" = "darwin" ] && HASH="b3ed5a7"
[ "$OS" = "linux" ] && HASH="ee0f12c"

download-and-check \
  -u "https://github.com/sharkdp/bat/releases/download/v$VERSION/bat-v$VERSION-$PKGS_ARCH-$OS_IDENTIFIER.tar.gz" \
  -f "$FILE" \
  -h "$HASH"

TO="$PKGS_LIB/bat"
mkdir -p "$TO"
tar xf "$FILE" --strip-components=1 -C "$TO"
install -Dm755 "$TO/bat" "$PKGS_BIN/bat"
rm -rf "$TO"
