#!/bin/bash

PACKAGE=attr
source common.sh
ensure_clean_unpacked

./configure --prefix=/usr     \
            --disable-static  \
            --sysconfdir=/etc \
            --docdir="/usr/share/doc/$(package_slug $PACKAGE)"

make "-j$(nproc)"

make check

make install
