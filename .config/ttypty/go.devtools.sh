#!/bin/sh -e
[ -z "$GOPATH" ] && exit 1
echo "managing go tools"
for TOOL in \
  mvdan.cc/gofumpt \
  golang.org/x/tools/gopls \
  honnef.co/go/tools/cmd/staticcheck \
  github.com/enckse/lockbox/cmd/lb \
  github.com/mgechev/revive \
  ; do
    echo "-> $TOOL"
    go install "$TOOL@latest"
done
