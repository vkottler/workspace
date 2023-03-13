#!/bin/bash

PACKAGE=zstd
source common.sh
ensure_unpacked

make "-j$(nproc)" prefix=/usr
make check
make prefix=/usr install

rm -v /usr/lib/libzstd.a
