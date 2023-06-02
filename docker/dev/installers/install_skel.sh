#!/usr/bin/env bash

# Fail on first error.
set -e
# SKEL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../../../skel" && pwd)"
SKEL_DIR="/tmp/skel"
echo ${SKEL_DIR}
cd "$(dirname "${BASH_SOURCE[0]}")"

rm -rf /etc/skel
cd /etc
cp -r ${SKEL_DIR} .
