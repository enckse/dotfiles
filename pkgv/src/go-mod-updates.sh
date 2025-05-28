#!/bin/sh -e
[ ! -e 'go.mod' ] && echo 'cowardly failing to run go mod commands' && exit 1
go get -u ./...
go mod tidy
