#!/bin/bash

PACKAGE=man-pages
source common.sh
ensure_unpacked

make prefix=/usr install
