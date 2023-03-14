#!/bin/bash

PACKAGE="grep"
source common.sh
ensure_clean_unpacked

sed -i "s/echo/#echo/" src/egrep.sh

./configure --prefix=/usr

make_check_install
