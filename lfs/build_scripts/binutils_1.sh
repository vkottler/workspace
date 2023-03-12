#!/bin/bash

PACKAGE=binutils
source common.sh
ensure_unpacked

mkdir -vp build
pushd build >/dev/null || exit

../configure --prefix="$LFS/tools" \
             --with-sysroot="$LFS" \
             --target="$LFS_TGT" \
             --disable-nls \
             --enable-gprofng=no \
             --disable-werror

make_install

popd >/dev/null || exit
