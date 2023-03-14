#!/bin/bash

PACKAGE=ncurses
source common.sh
ensure_unpacked

sed -i s/mawk// configure

mkdir -vp build
pushd build >/dev/null || exit

../configure
make "-j$(nproc)" -C include
make "-j$(nproc)" -C progs tic

popd >/dev/null || exit

./configure --prefix=/usr \
            --host="$LFS_TGT" \
            --build="$(./config.guess)" \
            --mandir=/usr/share/man \
            --with-manpage-format=normal \
            --with-shared \
            --without-normal \
            --with-cxx-shared \
            --without-debug \
            --without-ada \
            --disable-stripping \
            --enable-widec

make "-j$(nproc)"

make DESTDIR="$LFS" TIC_PATH="$(pwd)/build/progs/tic" install
echo "INPUT(-lncursesw)" > "$LFS/usr/lib/libncurses.so"
