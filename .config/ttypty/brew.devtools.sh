#!/bin/sh -ue
echo "managing brew installed packages"
brew ls  --formula -1 | sort > "$HOME/.config/ttypty/world"
