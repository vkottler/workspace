#!/bin/bash

PACKAGE=gdbm
source common.sh
ensure_unpacked

./configure --prefix=/usr    \
            --disable-static \
            --enable-libgdbm-compat

make_check_install
