#!/bin/bash

REPO=$(git rev-parse --show-toplevel)
CWD=$REPO/lfs
source "$CWD/env"

sudo groupadd lfs
sudo useradd -s /bin/bash -g lfs -m -k /dev/null lfs

sudo chown -v lfs $LFS/{usr{,/*},lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) sudo chown -v lfs $LFS/lib64 ;;
esac
