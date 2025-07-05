#!/bin/sh

# <xbar.title>Git Info</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.desc>Displays git changes</xbar.desc>
#
# Dependencies: none.

_gitcmd() {
  HEADER=$(echo "$2" | cut -d " " -f 1)
  /usr/bin/git -C "$1" ${2} | sed "s/^/ -> /g;s/$/ ($HEADER)/g"
}

GITDIRTY_ISSUE=""
GITDIRTY_HIGHLIGHT=""
GITDIRTY="❌"
GITCLEAN="✅"
GITDIRTY_NORMAL=''
GITCLEAN_NORMAL=''

_gitstatus() {
  BASE=$(echo "$1" | sed "s#$HOME/##g")
  {
    _gitcmd "$1" "update-index -q --refresh"
    _gitcmd "$1" "diff-index --name-only HEAD --"
    _gitcmd "$1" "log --branches --not --remotes -n 1"
    _gitcmd "$1" "ls-files --others --exclude-standard --directory --no-empty-directory"
    _gitcmd "$1" "branch --show-current" | grep -E -v ' (master|main) \(branch\)$'
  } | sed "s#^#$BASE#g"
}

FOUND=0
{
  for DIR in .ttypty Workspace; do
    for SUB in $(ls "$HOME/$DIR"); do
      REPO="$HOME/$DIR/$SUB"
      [ ! -d "$REPO/.git" ] && continue
      SCAN=$(git -C "$REPO" config "status.scan" 2>/dev/null)
      [ -z "$SCAN" ] && SCAN="true"
      [ "$SCAN" != "true" ] && continue
      STATUS=$(_gitstatus "$REPO" | grep -v '^$')
      [ -z "$STATUS" ] && continue
      [ "$FOUND" -eq 0 ] && printf " ${GITDIRTY_ISSUE}${GITDIRTY}${GITDIRTY_NORMAL}\n---\n" && FOUND=1
      echo "$STATUS"
    done
  done
  if [ "$FOUND" -eq 0 ]; then
    printf " ${GITDIRTY_HIGHLIGHT}${GITCLEAN}${GITCLEAN_NORMAL}\n---"
  fi
} 2>/dev/null
