#!/bin/sh -e
NAME="devcontainer"
WORKDIR="$HOME/.local/state/devcontainer"
CONTAINER_APKS="$WORKDIR/apks"
mkdir -p "$CONTAINER_APKS"
CONFIGS="$HOME/.config/devcontainer"

IS_STOP=0
IS_START=1
REBUILD_CMD="rebuild"
STOP_CMD="stop"
START_CMD="start"
case "$1" in
  "$START_CMD")
    ;;
  "$STOP_CMD")
    IS_STOP=1
    IS_START=0
    ;;
  "$REBUILD_CMD")
    IS_STOP=1
    ;;
  "completions")
    cat << EOF
    #compdef _$NAME $NAME

_$NAME() {

  local curcontext="\$curcontext" state len
  typeset -A opt_args
  _arguments     '1: :->main'    '*: :->args'

  len=\${#words[@]}
  case \$state in
    main)
        _arguments "1:main:($STOP_CMD $REBUILD_CMD $START_CMD)"
    ;;
    *)
  esac


}

compdef _$NAME $NAME
EOF
    exit 0
    ;;
  *)
    echo "command required"
    exit 1
esac

if [ "$IS_STOP" -eq 1 ]; then
  container stop "$NAME" && echo "not started"
  [ "$IS_START" -eq 0 ] && exit 0
  container image delete "$NAME" && echo "no image"
fi

if [ -z "$DEVCONTAINER_USER_NAME" ] || [ -z "$DEVCONTAINER_HOME" ]; then
  echo "no user/home set"
  exit 1
fi

[ -z "$1" ] && echo "no command?" && exit 1

if ! container volume ls --format json | jq -r ".[].name" | grep -q "$NAME"; then
  container volume create -s 10G "$NAME"
fi

if ! container image ls --format json | jq -r ".[].reference" | grep -q "$NAME:latest"; then
  container build --build-arg USER_NAME="$DEVCONTAINER_USER_NAME" --no-cache --tag "$NAME" -f "$CONFIGS/Containerfile" "$WORKDIR"
fi

if ! container ls --format json | jq -r ".[].configuration.id" | grep -q "$NAME"; then
  MOUNTS=""
  for f in $DEVCONTAINER_MOUNTS; do
    MOUNTS="$MOUNTS --mount type=bind,source=$HOME/$f,target=$DEVCONTAINER_HOME/$f"
  done
  
  container run --rm --detach \
    --name "$NAME" \
    --volume "$NAME:$DEVCONTAINER_HOME" \
    $DEVCONTAINER_ARGS \
    --mount type=bind,source="$CONTAINER_APKS",target=/etc/apk/cache \
    $MOUNTS \
    "$NAME"
fi
