#!/bin/sh -e
VERSION=1.40.0
[ "$OS" = "darwin" ] && HASH="0fb2401"
[ "$OS" = "linux" ] && HASH="d065d0d"
FILE="$PKGS_WD/$VERSION.just.tar.gz"

download-and-check \
  -u "https://github.com/casey/just/releases/download/$VERSION/just-$VERSION-$PKGS_ARCH-$OS_IDENTIFIER.tar.gz" \
  -f "$FILE" \
  -h "$HASH"

TO="$PKGS_LIB/just"
mkdir -p "$TO"
tar xf "$FILE" -C "$TO"
install -Dm755 "$TO/just" "$PKGS_BIN/just"
install -Dm644 "$TO/completions/just.$USE_SHELL" "$PKGS_COMP/just"
rm -rf "$TO"
