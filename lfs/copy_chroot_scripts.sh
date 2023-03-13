#!/bin/bash

REPO=$(git rev-parse --show-toplevel)
CWD=$REPO/lfs
source "$CWD/env"

# Use root's home directory.
sudo cp -r "$CWD/chroot_scripts" $LFS/root/
sudo cp -r "$CWD/build_scripts" $LFS/root/chroot_scripts/
