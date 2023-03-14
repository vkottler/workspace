#!/bin/bash

PACKAGE=less
source common.sh
ensure_unpacked

./configure --prefix=/usr --sysconfdir=/etc

make_install
