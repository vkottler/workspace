#!/bin/bash

REPO=$(git rev-parse --show-toplevel)
CWD=$REPO/lfs
source "$CWD/env"

# Can also add this to /etc/fstab like:
# $LFS_PART $LFS ext4 defaults 1 1
sudo mount -v -t ext4 $LFS_PART $LFS
