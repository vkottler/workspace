#!/bin/bash

PACKAGE=gettext
source common.sh
ensure_unpacked

./configure --disable-shared

make "-j$(nproc)"

cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin
