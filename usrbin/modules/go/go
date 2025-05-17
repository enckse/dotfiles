#!/bin/sh -e
VERSION=1.24.3
[ "$OS" = "darwin" ] && HASH="64a3fa2"
[ "$OS" = "linux" ] && HASH="8df5750"
FILE="$PKGS_WD/$VERSION.go.tar.gz"

download-and-check \
  -u "https://go.dev/dl/go$VERSION.$OS-$PKGS_ALTARCH.tar.gz" \
  -f "$FILE" \
  -h "$HASH" \
  -p "https://github.com/golang/go"

tar xf "$FILE" -C "$PKGS_LIB"
(cd "$PKGS_BIN" && ln -sf "../$PKGS_LIB_DIR/go/bin/go" go)
