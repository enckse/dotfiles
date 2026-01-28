#!/bin/sh
export DEVCONTAINER_USER_NAME="enck"
export DEVCONTAINER_MOUNTS="Workspace Downloads .ttypty .ssh"
export DEVCONTAINER_HOME="/home/$DEVCONTAINER_USER_NAME"
export DEVCONTAINER_ARGS="--memory=4G"

ssh_devcontainer() {
  devcontainer start
  IP=$(container ls --format json | jq ".[] | select(.configuration.id == \"devcontainer\")" | jq -r '.networks.[0].address' | cut -d "/" -f 1)
  [ -z "$IP" ] && echo "no ip?" && return
  TO="$DEVCONTAINER_HOME"
  for DIR in $(echo $DEVCONTAINER_MOUNTS | tr ' ' '\n'); do
    if echo "$PWD" | grep -q "/$DIR"; then
      TO="$(echo "$PWD" | sed "s#$HOME/#$DEVCONTAINER_HOME/#g")"
    fi
  done
  ssh -t "$IP" -- "cd '$TO'; exec bash --login"
}
