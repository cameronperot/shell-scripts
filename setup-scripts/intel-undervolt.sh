#!/usr/bin/env bash
set -eu -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P )"

SOURCE_DIR=/tmp/intel-undervolt
sudo rm -rf ${SOURCE_DIR}

git clone https://github.com/kitsunyan/intel-undervolt.git ${SOURCE_DIR}
cd ${SOURCE_DIR}
./configure --enable-systemd
make
sudo make install

sudo rm -rf ${SOURCE_DIR}

sudo intel-undervolt apply
sudo intel-undervolt read
sudo systemctl enable intel-undervolt.service
