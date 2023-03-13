#!/bin/bash

PACKAGE=Python
source common.sh
ensure_unpacked

./configure --prefix=/usr   \
            --enable-shared \
            --without-ensurepip

make "-j$(nproc)"
make install
