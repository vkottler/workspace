#!/bin/bash

PACKAGE=mpfr
source common.sh
ensure_unpacked

sed -e 's/+01,234,567/+1,234,567 /' \
    -e 's/13.10Pd/13Pd/'            \
    -i tests/tsprintf.c

./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir="/usr/share/doc/$(package_slug $PACKAGE)"

make "-j$(nproc)"
make html

make check

make install
make install-html
