#!/bin/bash

PACKAGE=acl
source common.sh
ensure_unpacked

./configure --prefix=/usr         \
            --disable-static      \
            --docdir="/usr/share/doc/$(package_slug $PACKAGE)"

make "-j$(nproc)"
make install
