#!/bin/bash

REPO=$(git rev-parse --show-toplevel)
CWD=$REPO/lfs
source "$CWD/env"

sudo chown -R root:root $LFS/{usr,lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) sudo chown -R root:root $LFS/lib64 ;;
esac
