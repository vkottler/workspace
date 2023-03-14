#!/bin/bash

PACKAGE=bison
source common.sh
ensure_clean_unpacked

./configure --prefix=/usr --docdir="$DOCDIR"

make_check_install
