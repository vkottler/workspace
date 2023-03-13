#!/bin/bash

PACKAGE=iana-etc
source common.sh
ensure_unpacked

cp services protocols /etc
