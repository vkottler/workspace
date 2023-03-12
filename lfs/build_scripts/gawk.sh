#!/bin/bash

PACKAGE=gawk
source common.sh
ensure_unpacked

sed -i 's/extras//' Makefile.in

./configure --prefix=/usr \
            --host="$LFS_TGT" \
            --build="$(build-aux/config.guess)"

make "-j$(nproc)"
make DESTDIR="$LFS" install
