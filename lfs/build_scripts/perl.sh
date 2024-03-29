#!/bin/bash

PACKAGE=perl
source common.sh
ensure_clean_unpacked

export BUILD_ZLIB=False
export BUILD_BZIP2=0

PERL_ROOT="/usr/lib/perl5/${VERSIONS[perl]}"

sh Configure -des \
             -Dprefix=/usr \
             -Dvendorprefix=/usr \
             -Dprivlib="$PERL_ROOT/core_perl" \
             -Darchlib="$PERL_ROOT/core_perl" \
             -Dsitelib="$PERL_ROOT/site_perl" \
             -Dsitearch="$PERL_ROOT/site_perl" \
             -Dvendorlib="$PERL_ROOT/vendor_perl" \
             -Dvendorarch="$PERL_ROOT/vendor_perl" \
             -Dman1dir=/usr/share/man/man1 \
             -Dman3dir=/usr/share/man/man3 \
             -Dpager="/usr/bin/less -isR" \
             -Duseshrplib \
             -Dusethreads

make_nproc

make test

make install

unset BUILD_ZLIB BUILD_BZIP2
