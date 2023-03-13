#!/bin/bash

PACKAGE=binutils
source common.sh
ensure_clean_unpacked

expect -c "spawn ls"

mkdir -vp build
pushd build >/dev/null || exit

../configure --prefix=/usr       \
             --sysconfdir=/etc   \
             --enable-gold       \
             --enable-ld=default \
             --enable-plugins    \
             --enable-shared     \
             --disable-werror    \
             --enable-64-bit-bfd \
             --with-system-zlib

make "-j$(nproc)" tooldir=/usr
make -k check || true

grep '^FAIL:' "$(find . -name '*.log')" || true

make tooldir=/usr install

popd >/dev/null || exit

rm -fv /usr/lib/lib{bfd,ctf,ctf-nobfd,sframe,opcodes}.a
rm -fv /usr/share/man/man1/{gprofng,gp-*}.1
