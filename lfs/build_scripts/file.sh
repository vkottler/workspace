#!/bin/bash

PACKAGE="file"
source common.sh
ensure_unpacked

mkdir -vp build
pushd build >/dev/null || exit

../configure --disable-bzlib \
             --disable-libseccomp \
             --disable-xzlib \
             --disable-zlib

make "-j$(nproc)"

popd >/dev/null || exit

./configure --prefix=/usr --host="$LFS_TGT" --build="$(./config.guess)"

make "-j$(nproc)" FILE_COMPILE="$(pwd)/build/src/file"
make DESTDIR="$LFS" install

rm -v "$LFS/usr/lib/libmagic.la"
