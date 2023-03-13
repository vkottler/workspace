#!/bin/bash

PACKAGE=zlib
source common.sh
ensure_unpacked

./configure --prefix=/usr
make "-j$(nproc)"
make check
make install
rm -fv /usr/lib/libz.a
