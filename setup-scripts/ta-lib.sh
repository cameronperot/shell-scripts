#!/usr/bin/env bash
set -eu -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P )"

# https://ta-lib.org/install/
VERSION="0.4.0"
URL="http://prdownloads.sourceforge.net/ta-lib/ta-lib-${VERSION}-src.tar.gz"

# download and extract
wget -O /tmp/ta-lib.tar.gz ${URL}
tar -xvf /tmp/ta-lib.tar.gz -C /tmp
ORIGINAL_DIR=${PWD}
cd /tmp/ta-lib

# build and install
./configure --prefix=/usr
make
make install

# clean up
cd ${ORIGINAL_DIR}
rm -rf /tmp/ta-lib
