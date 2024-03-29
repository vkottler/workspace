#!/bin/bash

PACKAGE=gettext
source common.sh
ensure_clean_unpacked

./configure --prefix=/usr    \
            --disable-static \
            --docdir="$DOCDIR"

make_check_install

chmod -v 0755 /usr/lib/preloadable_libintl.so
