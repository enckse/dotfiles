#!/usr/bin/env bash
machine=$(get_next_machine)
name=$(get_machine_name $machine)
echo "building $machine"
mkdir -p $machine
ipaddr=$(get_ip_from_path $machine)
ip="$ipaddr:none:$VMR_GATEWAY:$VMR_NETMASK:$name::none:$VMR_DNS"

_build_env() {
    echo "#!/usr/bin/env bash"
    cat <<EOF
IP='$ip'
SSH_KEY='$(cat $VMR_SSH_KEY)'
REPO='$VMR_REMOTE_REPO'
VMLINUZ='$VMR_CURRENT_STORE/$VMR_VMLINUZ'
INITRAMFS='$VMR_CURRENT_STORE/$VMR_INITRAM'
ISO='$VMR_CURRENT_STORE/$VMR_BOOT_ISO'
ROOT='$machine'
TAGFILE='$machine/$VMR_TAG'
CONFIGS='$VMR_CONFIGS'
IMAGE='$VMR_IMG_NAME'

cd $machine

EOF
    cat $VMRLIB/lib.start.sh
}

start_sh=$machine/$VMR_START_SH
_build_env > $start_sh
chmod u+x $start_sh
echo $name > $machine/$VMR_NAME_SH
if [ ! -z "$1" ]; then
    if [[ "$1" == "--start" ]]; then
        $VMRLIB/start.sh $(get_number_from_ip $ipaddr) ${@:2}
    fi
fi