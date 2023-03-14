#!/bin/bash

PACKAGE=automake
source common.sh
ensure_unpacked

./configure --prefix=/usr --docdir="$DOCDIR"

make_nproc
make "-j$(nproc)" check
make install
