#!/bin/bash

PACKAGE=bash
source common.sh
ensure_clean_unpacked

./configure --prefix=/usr             \
            --without-bash-malloc     \
            --with-installed-readline \
            --docdir="$DOCDIR"

make_install
