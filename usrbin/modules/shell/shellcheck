#!/bin/sh -e
VERSION=0.10.0
FILE="$PKGS_WD/$VERSION.shellcheck.tar.xz"
[ "$OS" = "darwin" ] && HASH="bbd2f14"
[ "$OS" = "linux" ] && HASH="324a7e8"

download-and-check \
  -u "https://github.com/koalaman/shellcheck/releases/download/v$VERSION/shellcheck-v$VERSION.$OS.$PKGS_ARCH.tar.xz" \
  -f "$FILE" \
  -h "$HASH"

tar xf "$FILE" -C "$PKGS_LIB"
TO="$PKGS_LIB/shellcheck-v$VERSION"
install -Dm755 "$TO/shellcheck" "$PKGS_BIN/shellcheck"
rm -rf "$TO"
