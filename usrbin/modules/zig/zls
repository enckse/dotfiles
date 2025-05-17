#!/bin/sh -e
VERSION=0.14.0
[ "$OS" = "darwin" ] && HASH="dfb627e"
FILE="$PKGS_WD/$VERSION.zls.tar.gz"

download-and-check \
  -u "https://github.com/zigtools/zls/releases/download/$VERSION/zls-$PKGS_ARCH-$OS_ALT.tar.xz" \
  -f "$FILE" \
  -h "$HASH" \

TO="$PKGS_LIB/zls"
mkdir -p "$TO"
tar xf "$FILE" -C "$TO"
install -Dm755 "$TO/zls" "$PKGS_BIN/zls"
rm -rf "$TO"
