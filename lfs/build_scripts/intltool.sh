#!/bin/bash

PACKAGE=intltool
source common.sh
ensure_unpacked

sed -i 's:\\\${:\\\$\\{:' intltool-update.in

./configure --prefix=/usr

make_check_install

install -v -Dm644 doc/I18N-HOWTO "$DOCDIR/I18N-HOWTO"
