#!/bin/bash

PACKAGE=binutils
source common.sh
ensure_unpacked

sed '6009s/$add_dir//' -i ltmain.sh

rm -rf build
mkdir -vp build
pushd build >/dev/null || exit

../configure \
    --prefix=/usr \
    --build="$(../config.guess)" \
    --host="$LFS_TGT" \
    --disable-nls \
    --enable-shared \
    --enable-gprofng=no \
    --disable-werror \
    --enable-64-bit-bfd

make "-j$(nproc)"
make DESTDIR="$LFS" install

popd >/dev/null || exit

rm -v "$LFS"/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes}.{a,la}
