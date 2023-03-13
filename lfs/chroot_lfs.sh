#!/bin/bash

REPO=$(git rev-parse --show-toplevel)
CWD=$REPO/lfs
source "$CWD/env"

sudo chroot "$LFS" /usr/bin/env -i \
    HOME=/root \
    TERM="$TERM" \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin \
    /bin/bash --login
