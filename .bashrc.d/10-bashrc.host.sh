#!/usr/bin/env bash
if ! git uncommitted --quiet; then
  echo
  echo "uncommitted:"
  git uncommitted | cut -d " " -f 1 | sort -u | sed "s#$HOME/##g" | sed 's/^/  -> /g'
  echo
fi

if ! upstreams --check; then
  echo
  echo "upstreams:"
  echo "  -> check for updates"
  echo
fi

_backups() {
  systemctl start --user backups
  if data-sync --check; then
    return
  fi
  echo
  echo "backups:"
  echo "  -> backup issues"
  echo
}

_lb-completions() {
  local file cnt
  file="$HOME/.bashrc.d/99-lockbox.host.sh"
  if [ -s "$file" ]; then
    cnt=$(find "$file" -mtime +1 -type f | wc -l)
    if [ "$cnt" -eq 0 ]; then
      return
    fi
  fi
  lb bash 2>/dev/null > "$file"
}

_lb-completions
_backups
system-ostree check
