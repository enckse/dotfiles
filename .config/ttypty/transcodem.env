#!/bin/sh -e

transcodem_jpg() {
  _transcodem_rename "$1" "$2" "$3"
}

transcodem_jpeg() {
  _transcodem_rename "$1" "$2" "$3"
}

transcodem_mov() {
  _transcodem_rename "$1" "$2" "$3"
}

_transcodem_rename() {
  [ -z "$1" ] && echo "template name not given" && return
  [ -z "$2" ] && echo "extension not given" && return
  [ -z "$3" ] && echo "source file not given" && return
  to="$1$2"
  echo "renaming: $3"
  echo "  -> $to"
  mv "$3" "$to"
}

transcodem_heic() {
  [ -z "$1" ] && echo "template name not given" && return
  [ -z "$3" ] && echo "source file not given" && return
  tmpl="${1}jpeg"
  echo "formatting: $3"
  sips --setProperty format jpeg --out "${tmpl}" "$3" 2>&1 | sed 's#^\s*##g' | sed 's#^#  -> #g'
  if [ -e "$tmpl" ]; then
    rm -f "$3"
  fi
}
