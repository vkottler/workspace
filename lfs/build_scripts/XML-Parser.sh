#!/bin/bash

PACKAGE=XML-Parser
source common.sh
ensure_unpacked

perl Makefile.PL

make_test_install
