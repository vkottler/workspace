#!/bin/bash

PACKAGE=bzip2
source common.sh
ensure_unpacked

patch -Np1 -i ../bzip2-1.0.8-install_docs-1.patch || true

sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile

sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

make "-j$(nproc)" -f Makefile-libbz2_so
make clean

make "-j$(nproc)"
make PREFIX=/usr install

cp -av libbz2.so.* /usr/lib
ln -sv libbz2.so.1.0.8 /usr/lib/libbz2.so

cp -v bzip2-shared /usr/bin/bzip2
for i in /usr/bin/{bzcat,bunzip2}; do
	ln -sfv bzip2 "$i"
done

rm -fv /usr/lib/libbz2.a
