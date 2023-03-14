#!/bin/bash

PACKAGE=autoconf
source common.sh
ensure_unpacked

sed -e 's/SECONDS|/&SHLVL|/'               \
    -e '/BASH_ARGV=/a\        /^SHLVL=/ d' \
    -i.orig tests/local.at

./configure --prefix=/usr

make_nproc
make check TESTSUITEFLAGS="-j$(nproc)"
make install
