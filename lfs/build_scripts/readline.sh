#!/bin/bash

PACKAGE=readline
source common.sh
ensure_unpacked

sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install

patch -Np1 -i ../readline-8.2-upstream_fix-1.patch || true

SLUG=$(package_slug $PACKAGE)

./configure --prefix=/usr    \
            --disable-static \
            --with-curses    \
            --docdir="/usr/share/doc/$SLUG"

make SHLIB_LIBS="-lncursesw" "-j$(nproc)"
make SHLIB_LIBS="-lncursesw" install

install -v -m644 doc/*.{ps,pdf,html,dvi} "/usr/share/doc/$SLUG"
