#!/bin/bash

PACKAGE="xz"
source common.sh
ensure_unpacked

./configure --prefix=/usr \
            --host="$LFS_TGT" \
            --build="$(build-aux/config.guess)" \
            --disable-static \
            --docdir="/usr/share/doc/$(package_slug $PACKAGE)"

make "-j$(nproc)"
make DESTDIR="$LFS" install
rm -v "$LFS/usr/lib/liblzma.la"
