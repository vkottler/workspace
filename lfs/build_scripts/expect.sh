#!/bin/bash

PACKAGE=expect
source common.sh
SLUG="$PACKAGE${VERSIONS[$PACKAGE]}"

pushd "/sources" >/dev/null || exit

if [ ! -d "$SLUG" ]; then
	tar xf "$SLUG.tar.gz"
fi

pushd "$SLUG" >/dev/null || exit

trap double_pop EXIT

./configure --prefix=/usr \
            --with-tcl=/usr/lib \
            --enable-shared \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include

make "-j$(nproc)"
make test
make install

ln -svf "$SLUG/lib$SLUG.so" /usr/lib
