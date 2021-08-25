#!/usr/bin/env bash
set -eu -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P )"

INTEGRATE=${1:-true}
SOURCE_DIR=/tmp/firejail
sudo rm -rf ${SOURCE_DIR}

git clone https://github.com/netblue30/firejail.git ${SOURCE_DIR}
cd ${SOURCE_DIR}
./configure
make
sudo make install-strip


if [ ${INTEGRATE} = 'true' ]; then
    firecfg --fix-sound
    sudo firecfg
fi

sudo rm -rf ${SOURCE_DIR}
