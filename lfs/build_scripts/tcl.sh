#!/bin/bash

PACKAGE=tcl
source common.sh
SLUG="$PACKAGE${VERSIONS[$PACKAGE]}"

pushd "/sources" >/dev/null || exit

if [ ! -d "$SLUG-src" ]; then
	tar xf "$SLUG-src.tar.gz"
fi

pushd "$SLUG" >/dev/null || exit

trap double_pop EXIT

SRCDIR=$(pwd)

pushd unix >/dev/null

./configure --prefix=/usr \
            --mandir=/usr/share/man

make "-j$(nproc)"

sed -e "s|$SRCDIR/unix|/usr/lib|" \
    -e "s|$SRCDIR|/usr/include|"  \
    -i tclConfig.sh

sed -e "s|$SRCDIR/unix/pkgs/tdbc1.1.5|/usr/lib/tdbc1.1.5|" \
    -e "s|$SRCDIR/pkgs/tdbc1.1.5/generic|/usr/include|"    \
    -e "s|$SRCDIR/pkgs/tdbc1.1.5/library|/usr/lib/tcl8.6|" \
    -e "s|$SRCDIR/pkgs/tdbc1.1.5|/usr/include|"            \
    -i pkgs/tdbc1.1.5/tdbcConfig.sh

sed -e "s|$SRCDIR/unix/pkgs/itcl4.2.3|/usr/lib/itcl4.2.3|" \
    -e "s|$SRCDIR/pkgs/itcl4.2.3/generic|/usr/include|"    \
    -e "s|$SRCDIR/pkgs/itcl4.2.3|/usr/include|"            \
    -i pkgs/itcl4.2.3/itclConfig.sh

unset SRCDIR

make test
make install

chmod -v u+w /usr/lib/libtcl8.6.so

make install-private-headers

ln -sfv tclsh8.6 /usr/bin/tclsh

mv /usr/share/man/man3/{Thread,Tcl_Thread}.3

popd >/dev/null

tar -xf "../$SLUG-html.tar.gz" --strip-components=1
mkdir -v -p "/usr/share/doc/$SLUG"
cp -v -r  ./html/* "/usr/share/doc/$SLUG"
