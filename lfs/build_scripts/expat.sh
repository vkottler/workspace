#!/bin/bash

PACKAGE=expat
source common.sh
ensure_unpacked

./configure --prefix=/usr    \
            --disable-static \
            --docdir="$DOCDIR"

make_check_install

install -v -m644 doc/*.{html,css} "$DOCDIR"
