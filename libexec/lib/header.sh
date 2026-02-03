#!/bin/sh -e
START_LINE=14

VERSION="development"

[ -n "$1" ] && [ "$1" = "--version" ] && echo "version: $VERSION" && exit 0

_unpack() {
  tail -n +"$START_LINE" "$0" | base64 -d
}

_unpack | sh -s $@
exit 0
