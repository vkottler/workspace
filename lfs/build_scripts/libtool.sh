#!/bin/bash

PACKAGE=libtool
source common.sh
ensure_unpacked

./configure --prefix=/usr

make_nproc

make -k check TESTSUITEFLAGS="-j$(nproc)" || true

make install

rm -fv /usr/lib/libltdl.a
