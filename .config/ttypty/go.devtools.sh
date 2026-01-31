#!/bin/sh -e
[ -z "$GOPATH" ] && exit 1
echo "managing go tools"
_gotool() {
  echo "-> $1"
  go install "$1@latest"
}
_gotool "mvdan.cc/gofumpt"
_gotool "golang.org/x/tools/gopls"
_gotool "honnef.co/go/tools/cmd/staticcheck"
_gotool "github.com/mgechev/revive"
if [ -z "$NO_LB" ]; then
  _gotool "github.com/enckse/lockbox/cmd/lb"
  _gotool "github.com/theimpostor/osc"
fi
