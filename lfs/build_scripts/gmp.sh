#!/bin/bash

PACKAGE=gmp
source common.sh
ensure_unpacked

./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir="/usr/share/doc/$(package_slug "$PACKAGE")"

make "-j$(nproc)"
make html

make check 2>&1 | tee gmp-check-log

awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log

make install
make install-html
