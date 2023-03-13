#!/bin/bash

PACKAGE=util-linux
source common.sh
ensure_unpacked

mkdir -pv /var/lib/hwclock

./configure ADJTIME_PATH=/var/lib/hwclock/adjtime \
            --libdir=/usr/lib \
            --docdir="/usr/share/doc/$(package_slug "$PACKAGE")" \
            --disable-chfn-chsh \
            --disable-login \
            --disable-nologin \
            --disable-su \
            --disable-setpriv \
            --disable-runuser \
            --disable-pylibmount \
            --disable-static \
            --without-python \
            runstatedir=/run

make "-j$(nproc)"
make install
