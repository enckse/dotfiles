#!/bin/bash
pacman_status() {
    local oldifs deps cur prev f d size linux arch
    oldifs=$IFS
    IFS=$'\n'
    for f in $(pacman -Qqtd); do
        notify-send -t 30000 "orphan: $f"
    done
    deps=""
    for f in $(find ~/store/managed/PKGBUILD -maxdepth 2 -type f | grep -E "PKGBUILD|patch"); do
        for d in $(cat $f | grep "^depends" | cut -d "(" -f 2 | cut -d ")" -f 1 | sed "s/'//g" | sed 's/"//g'); do
            deps="$deps $d"
        done
    done
    IFS=$oldifs
    cur=~/.cache/package.deps
    prev=${cur}.prev
    touch $prev
    pacman -Si $(echo $deps | tr ' ' '\n' | sort -u) 2> /dev/null | grep -E "^(Name|Version)" > $cur
    diff -u $prev $cur
    if [ $? -ne 0 ]; then
        notify-send -t 30000 "PKGBUILD: deps"
    fi
    cp $cur $prev
    size=$(du -h /var/cache/pacman/pkg | tr '\t' ' ' | cut -d " " -f 1 | grep "G" | sed "s/G//g" | cut -d "." -f 1)
    if [ ! -z "$size" ]; then
        if [ $size -gt 10 ]; then
            notify-send -t 30000 "pkgcache: $size(G)"
        fi
    fi
    linux=$(pacman -Qi linux | grep Version | cut -d ":" -f 2 | sed "s/ //g")
    arch=$(uname -r | sed "s/-arch/.arch/g")
    if [ "$linux" != "$arch" ]; then
        notify-send -t 30000 "linux: kernel"
    fi
}
