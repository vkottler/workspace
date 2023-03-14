#!/bin/bash

PACKAGE=psmisc
source common.sh
ensure_unpacked

./configure --prefix=/usr

make "-j$(nproc)"
make install
