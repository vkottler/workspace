#!/bin/bash

PACKAGE="file"
source common.sh
ensure_unpacked

./configure --prefix=/usr
make "-j$(nproc)"
make check
make install
