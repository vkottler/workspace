#!/bin/bash

PACKAGE=perl
source common.sh
ensure_unpacked

PERL_ROOT="/usr/lib/perl5/${VERSIONS[perl]}"

sh Configure -des \
             -Dprefix=/usr \
             -Dvendorprefix=/usr \
             -Dprivlib="$PERL_ROOT/core_perl" \
             -Darchlib="$PERL_ROOT/core_perl" \
             -Dsitelib="$PERL_ROOT/site_perl" \
             -Dsitearch="$PERL_ROOT/site_perl" \
             -Dvendorlib="$PERL_ROOT/vendor_perl" \
             -Dvendorarch="$PERL_ROOT/vendor_perl"

make "-j$(nproc)"
make install
