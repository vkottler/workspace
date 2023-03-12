#!/bin/bash

PACKAGE=gcc
source common.sh
ensure_unpacked

for dep in mpfr gmp mpc; do
	# Ensure each dependency is unpacked.
	dep_slug=$(unpack_package $dep)

	# Link to the current directory.
	if [ ! -L "$dep" ]; then
		ln -s "../$dep_slug" $dep
	fi
done

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
  ;;
esac

sed '/thread_header =/s/@.*@/gthr-posix.h/' \
    -i libgcc/Makefile.in libstdc++-v3/include/Makefile.in

rm -rf build
mkdir -v build
pushd build >/dev/null || exit

../configure \
    --build="$(../config.guess)" \
    --host="$LFS_TGT" \
    --target="$LFS_TGT" \
    LDFLAGS_FOR_TARGET=-L"$PWD/$LFS_TGT/libgcc" \
    --prefix=/usr \
    --with-build-sysroot="$LFS" \
    --enable-default-pie \
    --enable-default-ssp \
    --disable-nls \
    --disable-multilib \
    --disable-libatomic \
    --disable-libgomp \
    --disable-libquadmath \
    --disable-libssp \
    --disable-libvtv \
    --enable-languages=c,c++

make "-j$(nproc)"
make DESTDIR="$LFS" install

popd >/dev/null || exit

ln -sv gcc "$LFS/usr/bin/cc"
