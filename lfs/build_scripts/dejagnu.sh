#!/bin/bash

PACKAGE=dejagnu
source common.sh
ensure_unpacked

mkdir -vp build
pushd build >/dev/null || exit

../configure --prefix=/usr
makeinfo --html --no-split -o doc/$PACKAGE.html ../doc/$PACKAGE.texi
makeinfo --plaintext       -o doc/$PACKAGE.txt  ../doc/$PACKAGE.texi

make install
SLUG=$(package_slug $PACKAGE)
install -v -dm755 "/usr/share/doc/$SLUG"
install -v -m644 doc/$PACKAGE.{html,txt} "/usr/share/doc/$SLUG"

make check

popd >/dev/null || exit
