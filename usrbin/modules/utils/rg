#!/bin/sh -e
VERSION=14.1.1
FILE="$PKGS_WD/$VERSION.rg.tar.gz"
[ "$OS" = "darwin" ] && HASH="24ad767"
[ "$OS" = "linux" ] && HASH="c827481"

download-and-check \
  -u "https://github.com/BurntSushi/ripgrep/releases/download/$VERSION/ripgrep-$VERSION-$PKGS_ARCH-$OS_IDENTIFIER.tar.gz" \
  -f "$FILE" \
  -h "$HASH"

TO="$PKGS_LIB/rg"
mkdir -p "$TO"
tar xf "$FILE" --strip-components=1 -C "$TO"
install -Dm755 "$TO/rg" "$PKGS_BIN/rg"
rm -rf "$TO"
