#!/bin/bash

PACKAGE=gcc
source common.sh
ensure_clean_unpacked

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac

mkdir -vp build
pushd build >/dev/null || exit

../configure --prefix=/usr            \
             LD=ld                    \
             --enable-languages=c,c++ \
             --enable-default-pie     \
             --enable-default-ssp     \
             --disable-multilib       \
             --disable-bootstrap      \
             --with-system-zlib

make "-j$(nproc)"

ulimit -s 32768

chown -Rv tester .
su tester -c "PATH=$PATH make -k check"
../contrib/test_summary | grep -A7 Summ

read -pr "Continue?"

make install

chown -v -R root:root \
    /usr/lib/gcc/"$(gcc -dumpmachine)"/"${VERSIONS[$PACKAGE]}"/include{,-fixed}

ln -svr /usr/bin/cpp /usr/lib

ln -sfv ../../libexec/gcc/"$(gcc -dumpmachine)"/"${VERSIONS[$PACKAGE]}"/liblto_plugin.so \
        /usr/lib/bfd-plugins/

# [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
read -pr "Continue?"

# /usr/lib/gcc/x86_64-pc-linux-gnu/12.2.0/../../../../lib/Scrt1.o succeeded
# /usr/lib/gcc/x86_64-pc-linux-gnu/12.2.0/../../../../lib/crti.o succeeded
# /usr/lib/gcc/x86_64-pc-linux-gnu/12.2.0/../../../../lib/crtn.o succeeded
grep -E -o '/usr/lib.*/S?crt[1in].*succeeded' dummy.log
read -pr "Continue?"

# #include <...> search starts here:
#  /usr/lib/gcc/x86_64-pc-linux-gnu/12.2.0/include
#  /usr/local/include
#  /usr/lib/gcc/x86_64-pc-linux-gnu/12.2.0/include-fixed
#  /usr/include
grep -B4 '^ /usr/include' dummy.log
read -pr "Continue?"

# SEARCH_DIR("/usr/x86_64-pc-linux-gnu/lib64")
# SEARCH_DIR("/usr/local/lib64")
# SEARCH_DIR("/lib64")
# SEARCH_DIR("/usr/lib64")
# SEARCH_DIR("/usr/x86_64-pc-linux-gnu/lib")
# SEARCH_DIR("/usr/local/lib")
# SEARCH_DIR("/lib")
# SEARCH_DIR("/usr/lib");
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
read -pr "Continue?"

# attempt to open /usr/lib/libc.so.6 succeeded
grep "/lib.*/libc.so.6 " dummy.log
read -pr "Continue?"

# found ld-linux-x86-64.so.2 at /usr/lib/ld-linux-x86-64.so.2
grep found dummy.log
read -pr "Continue?"

rm -v dummy.c a.out dummy.log

mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib

popd >/dev/null || exit
