#!/bin/bash

PACKAGE="make"
source common.sh
ensure_unpacked

sed -e '/ifdef SIGPIPE/,+2 d' \
    -e '/undef  FATAL_SIG/i FATAL_SIG (SIGPIPE);' \
    -i src/main.c

./configure --prefix=/usr \
            --without-guile \
            --host="$LFS_TGT" \
            --build="$(build-aux/config.guess)"

make "-j$(nproc)"
make DESTDIR="$LFS" install
