#!/bin/sh -ue
echo "managing brew installed packages"
brew list --installed-on-request -1 | sort > "$HOME/.config/ttypty/world"
