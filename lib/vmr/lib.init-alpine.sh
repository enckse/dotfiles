#!/bin/ash
echo "root:root" | chpasswd
echo "http://dl-cdn.alpinelinux.org/alpine/v{VERS}/main" > /etc/apk/repositories
echo "http://dl-cdn.alpinelinux.org/alpine/v{VERS}/community" >> /etc/apk/repositories
setup-timezone -z US/Michigan
setup-hostname {NAME}
setup-ntp -c chrony
blkid | grep -q "vdb"
if [ $? -ne 0 ]; then
    printf "y\n" | setup-disk -m data /dev/vdb
else
    mount -t ext4 /dev/vdb2 /var
fi
swapon /dev/vdb1
/etc/init.d/swap start
mkdir -p /var/cache/root
mkdir -p /var/cache/apkcache
mkdir -p /etc/apk/cache
cp -r /root/.ssh /var/cache/root/
mount --bind /var/cache/root /root
mount --bind /var/cache/apkcache /etc/apk/cache
echo > /etc/motd
hostname {NAME}
apk add bash bash-completion docs git make
sed -i "s#bin/ash#bin/bash#g" /etc/passwd
