#!/bin/sh -e
VERSION=0.14.0
[ "$OS" = "darwin" ] && HASH="b71e4b7"
FILE="$PKGS_WD/$VERSION.zig.tar.gz"

download-and-check \
  -u "https://ziglang.org/download/$VERSION/zig-${OS_ALT}-$PKGS_ARCH-$VERSION.tar.xz" \
  -f "$FILE" \
  -h "$HASH" \
  -p "https://github.com/ziglang/zig"

tar xf "$FILE" -C "$PKGS_LIB"
(cd "$PKGS_BIN" && ln -sf "../$PKGS_LIB_DIR/zig-${OS_ALT}-$PKGS_ARCH-$VERSION/zig" zig)
