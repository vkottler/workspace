#!/bin/bash

PACKAGE=pkg-config
source common.sh
ensure_unpacked

./configure --prefix=/usr \
            --with-internal-glib \
            --disable-host-tool \
            --docdir="/usr/share/doc/$(package_slug $PACKAGE)"

make "-j$(nproc)"
make check
make install
