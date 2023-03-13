#!/bin/bash

PACKAGE=mpc
source common.sh
ensure_clean_unpacked

./configure --prefix=/usr \
            --disable-static \
            --docdir="/usr/share/doc/$(package_slug $PACKAGE)"

make "-j$(nproc)"
make html

make check

make install
make install-html
