#!/bin/bash

PACKAGE=inetutils
source common.sh
ensure_unpacked

./configure --prefix=/usr        \
            --bindir=/usr/bin    \
            --localstatedir=/var \
            --disable-logger     \
            --disable-whois      \
            --disable-rcp        \
            --disable-rexec      \
            --disable-rlogin     \
            --disable-rsh        \
            --disable-servers

make_check_install

mv -v /usr/{,s}bin/ifconfig
