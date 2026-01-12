#!/bin/sh -e
[ -z "$GOPATH" ] && exit 1
echo "managing go tools"
for TOOL in \
  mvdan.cc/gofumpt \
  golang.org/x/tools/gopls \
  honnef.co/go/tools/cmd/staticcheck \
  github.com/mgechev/revive \
  github.com/enckse/lockbox/cmd/lb \
  ; do
    echo "-> $TOOL"
    go install "$TOOL@latest"
done
