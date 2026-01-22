#!/bin/sh
[ ! -d "$DEVCONTAINER_CACHE" ] && echo "no cache found/set" && exit 1
APKS="$DEVCONTAINER_CACHE/apks"
mkdir -p "$APKS"

KEY="$(uuidgen)"
export DEVCONTAINER_USER_HOME="/home/enck"
export DEVCONTAINER_USER_SHELL="/bin/bash"
export DEVCONTAINER_USER_MOUNTS="Workspace Downloads .ttypty .ssh"
export DEVCONTAINER_MOUNTS="--mount type=bind,source=$DEVCONTAINER_CACHE/home,target=$DEVCONTAINER_USER_HOME/ --mount type=bind,source=$APKS,target=/etc/apk/cache"
export DEVCONTAINER_ENVS="--env CONTAINER_UUID=$KEY"
export DEVCONTAINER_USER_APKS="$(cat "$HOME/.config/ttypty/world" | tr '\n' ' ')"
export DEVCONTAINER_RUN_ARGS="--memory=4G"
