#!/bin/sh

set -e

here="$(dirname "$0")"

. "$here/lib.sh"

root="$here/../nix-result"

rm -r "$root"
mkdir -p "$root"

go_rw binutils.c
go_rw binutils.types-src
go_rw binutils.values-src
