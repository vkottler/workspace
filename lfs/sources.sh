#!/bin/bash

REPO=$(git rev-parse --show-toplevel)
CWD=$REPO/lfs
source "$CWD/env"

LFS_URL=https://linuxfromscratch.org/lfs

SOURCES=$LFS/sources

if [ ! -d $SOURCES ]; then
	sudo mkdir -v $SOURCES
	sudo chmod -v a+wt $SOURCES
fi

WGET_LIST=wget-list-sysv

if [ ! -f "$CWD/$WGET_LIST" ]; then
	wget $LFS_URL/downloads/stable/$WGET_LIST -O "$CWD/$WGET_LIST"
fi

pushd $SOURCES >/dev/null || exit

wget --input-file="$CWD/$WGET_LIST" --continue --directory-prefix=$SOURCES

if [ ! -f md5sums ]; then
	wget $LFS_URL/downloads/stable/md5sums
fi

md5sum -c md5sums

popd >/dev/null || exit
