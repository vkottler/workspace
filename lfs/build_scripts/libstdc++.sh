#!/bin/bash

PACKAGE=gcc
source common.sh
ensure_unpacked

mkdir -vp build
pushd build >/dev/null || exit

../libstdc++-v3/configure \
    --host="$LFS_TGT" \
    --build="$(../config.guess)" \
    --prefix=/usr \
    --disable-multilib \
    --disable-nls \
    --disable-libstdcxx-pch \
    --with-gxx-include-dir=/tools/"$LFS_TGT"/include/c++/"${VERSIONS[gcc]}"

make -j4
make "DESTDIR=$LFS" install

popd >/dev/null || exit

rm -v "$LFS"/usr/lib/lib{stdc++,stdc++fs,supc++}.la
