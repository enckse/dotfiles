#!/bin/bash
glint() {
    if command -v go &> /dev/null; then
        local f
        goimports -l . | grep -v bindata.go | sed 's/^/[goimports]    /g'
        golint ./... | sed 's/^/[revive]       /g'
        for f in $(find . -type f -name "*.go" -exec dirname {} \; | sort -u); do
            go vet $f | sed 's/^/[govet]        /g'
        done
        golangci-lint run
    fi
}

nix-update() {
    nix-channel --update
    nix-env -iA nixpkgs.nix
}

_nixalias() {
    for f in $(find ~/.config/voidedtech -name "*.nix"); do
        alias nix-shell-$(basename $f | sed 's/\.nix//g')="nix-shell $f"
    done
}

_nixalias

