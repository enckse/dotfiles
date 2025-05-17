#!/bin/sh -e
VERSION=v0.42.2
FILE="$PKGS_WD/$VERSION.zellij.tar.gz"
[ "$OS" = "darwin" ] && HASH="a93c3b9"

#https://github.com/zellij-org/zellij/releases/download/v0.42.2/zellij-aarch64-apple-darwin.tar.gz
download-and-check \
  -u "https://github.com/zellij-org/zellij/releases/download/$VERSION/zellij-$PKGS_ARCH-$OS_DOUBLE.tar.gz" \
  -f "$FILE" \
  -h "$HASH"

TO="$PKGS_LIB/zellij"
mkdir -p "$TO"
tar xf "$FILE" -C "$TO"
install -Dm755 "$TO/zellij" "$PKGS_BIN/zellij"
rm -rf "$TO"
