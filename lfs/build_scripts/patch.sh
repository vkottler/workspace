#!/bin/bash

PACKAGE="patch"
source common.sh
ensure_unpacked

./configure --prefix=/usr \
            --host="$LFS_TGT" \
            --build="$(build-aux/config.guess)"

make "-j$(nproc)"
make DESTDIR="$LFS" install
