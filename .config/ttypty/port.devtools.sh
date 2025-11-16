#!/bin/sh -ue
echo "managing port installed packages"
port installed -q | sed 's/^\s*//g' | cut -d " " -f 1,2 | sed 's/@[0-9._-]*//g' | sort > "$HOME/.config/ttypty/world"
