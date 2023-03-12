#!/bin/bash

PACKAGE=bash
source common.sh
ensure_unpacked

./configure --prefix=/usr \
            --build="$(sh support/config.guess)" \
            --host="$LFS_TGT" \
            --without-bash-malloc

make "-j$(nproc)"
make DESTDIR="$LFS" install

ln -sv bash "$LFS/bin/sh"
