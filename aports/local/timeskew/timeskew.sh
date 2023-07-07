#!/usr/bin/env bash
_run() {
  local lt rt delta is_daemon hr
  is_daemon=0
  if [ "$1" == "--daemon" ]; then
    is_daemon=1
  fi
  while : ; do
    if [ "$is_daemon" -eq 1 ]; then
      hr=$(date +%H)
      if [ "$hr" -lt 6 ] || [ "$hr" -gt 21 ]; then
        sleep 1800
      else
        sleep 10
      fi
    fi
    rt=$(curl --silent "http://router.voidedtech.com/time")
    if [ -n "$rt" ] && [ "$rt" -eq "$rt" ] 2>/dev/null; then
      lt=$(date +%s)
      delta=0
    else
      echo "failed to get remote time" | logger -t timeskew
      if [ "$is_daemon" ]; then
        sleep 5
        continue
      fi
    fi
    if [ "$lt" -gt "$rt" ]; then
      delta=$((lt-rt))
    else
      if [ "$rt" -gt "$lt" ]; then
        delta=$((rt-lt))
      fi
    fi
    if [ "$is_daemon" -eq 1 ]; then
      if [ "$delta" -gt 10 ]; then
        {
          echo "delta detected, exceeds threshold: $delta (local: $lt, remote: $rt)"
          pkill chronyd
          rc-service chronyd restart
        } 2>&1 | logger -t timeskew
      fi
    else
      echo "delta: $delta, remote: $rt, local: $lt"
      return
    fi
  done
}

_kill() {
  local pid self
  self="$$"
  for pid in $(ps | grep "timeskew" | grep bash | awk '{print $1}'); do
    if [ "$pid" == "$self" ]; then
      continue
    fi
    kill -9 "$pid" 2>&1 | logger -t timeskew
  done
}

if [ -n "$1" ]; then
  if [ "$1" == "--daemon" ]; then
    _kill
    _run --daemon &
    exit 0
  fi
  echo "unknown argument: $1"
  exit 1
fi
_run
