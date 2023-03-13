#!/bin/bash

PACKAGE=flex
source common.sh
ensure_unpacked

./configure --prefix=/usr \
            --docdir="/usr/share/doc/$(package_slug $PACKAGE)" \
            --disable-static

make "-j$(nproc)"
make check
make install

ln -sv flex /usr/bin/lex
