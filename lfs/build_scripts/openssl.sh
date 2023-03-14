#!/bin/bash

PACKAGE=openssl
source common.sh
ensure_unpacked

./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic

make_nproc
make test

sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install

mv -v /usr/share/doc/openssl "$DOCDIR"
cp -vfr doc/* /usr/share/doc/openssl-3.0.8
