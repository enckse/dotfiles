#!/bin/sh -eu
echo "managing uv components"
for item in basedpyright \
            ruff \
  ; do
  echo "-> $item"
  uv tool install $item
  uv tool upgrade $item
done
