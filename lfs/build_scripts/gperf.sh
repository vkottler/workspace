#!/bin/bash

PACKAGE=gperf
source common.sh
ensure_unpacked

./configure --prefix=/usr --docdir="$DOCDIR"
make_check_install
