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
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
 ;;
esac

mkdir -v build

pushd build >/dev/null || exit

../configure \
    --target="$LFS_TGT" \
    --prefix="$LFS/tools" \
    --with-glibc-version="${VERSIONS[glibc]}" \
    --with-sysroot="$LFS" \
    --with-newlib \
    --without-headers \
    --enable-default-pie \
    --enable-default-ssp \
    --disable-nls \
    --disable-shared \
    --disable-multilib \
    --disable-threads \
    --disable-libatomic \
    --disable-libgomp \
    --disable-libquadmath \
    --disable-libssp \
    --disable-libvtv \
    --disable-libstdcxx \
    --enable-languages=c,c++

make_install

popd >/dev/null || exit

cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
	"$(dirname "$("$LFS_TGT-gcc" -print-libgcc-file-name)")"/install-tools/include/limits.h
