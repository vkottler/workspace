#!/bin/bash

PACKAGE="sed"
source common.sh
ensure_clean_unpacked

./configure --prefix=/usr

make "-j$(nproc)"
make html

chown -Rv tester .
su tester -c "PATH=$PATH make check"

make install
install -d -m755           "/usr/share/doc/$(package_slug $PACKAGE)"
install -m644 doc/sed.html "/usr/share/doc/$(package_slug $PACKAGE)"
