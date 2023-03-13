#!/bin/bash

PACKAGE=libcap
source common.sh
ensure_unpacked

sed -i '/install -m.*STA/d' libcap/Makefile

make "-j$(nproc)" prefix=/usr lib=lib

make test

make prefix=/usr lib=lib install
