#!/bin/bash

PACKAGE=bison
source common.sh
ensure_unpacked

./configure --prefix=/usr \
            --docdir="/usr/share/doc/$(package_slug "$PACKAGE")"

make "-j$(nproc)"
make install
