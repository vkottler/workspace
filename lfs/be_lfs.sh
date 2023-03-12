#!/bin/bash

REPO=$(git rev-parse --show-toplevel)
CWD=$REPO/lfs
source "$CWD/env"

sudo su - lfs
