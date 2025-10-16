#!/bin/sh -ue
PLUGINS="$HOME/.config/vim/pack/plugin/start"
mkdir -p "$PLUGINS"
echo "managing vim plugins"
for TOOL in \
  https://github.com/vim-airline/vim-airline \
  https://github.com/prabirshrestha/asyncomplete-buffer.vim \
  https://github.com/prabirshrestha/asyncomplete-lsp.vim \
  https://github.com/prabirshrestha/asyncomplete.vim \
  https://github.com/prabirshrestha/vim-lsp \
  https://github.com/bfrg/vim-qf-diagnostics \
  ; do
  BNAME=$(basename "$TOOL")
  DIR="$PLUGINS/$BNAME"
  echo "-> $BNAME"
  [ ! -d "$DIR" ] && git clone --quiet "$TOOL" "$DIR" && continue
  git -C "$DIR" pull --quiet
done
