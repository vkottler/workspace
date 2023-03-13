#!/bin/bash

PACKAGE="m4"
source common.sh
ensure_unpacked

./configure --prefix=/usr

make "-j$(nproc)"
make check
make install
