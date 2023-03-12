#!/bin/bash

PACKAGE=linux
source common.sh
ensure_unpacked

make mrproper

make headers
find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include "$LFS/usr"
