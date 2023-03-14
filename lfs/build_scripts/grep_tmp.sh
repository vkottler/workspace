#!/bin/bash

PACKAGE="grep"
source common.sh
ensure_unpacked

./configure --prefix=/usr \
            --host="$LFS_TGT"

make "-j$(nproc)"
make DESTDIR="$LFS" install
