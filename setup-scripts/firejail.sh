#!/usr/bin/env bash
set -eu -o pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"

sudo dnf install \
    automake \
    gawk \
    gcc \
    gcc-c++ \
    git \
    kernel-devel \
    libselinux-devel \
    make \
    pkg-config

VERSION="0.9.72"
INTEGRATE=${1:-true}
SOURCE_DIR="${HOME}/firejail"
sudo rm -rf "${SOURCE_DIR}"

git clone https://github.com/netblue30/firejail.git "${SOURCE_DIR}"
cd "${SOURCE_DIR}"
git checkout "${VERSION}"
./configure --enable-selinux
make
sudo make install-strip

if [ "${INTEGRATE}" = 'true' ]; then
    firecfg --fix-sound
    sudo firecfg
fi

sudo rm -rf "${SOURCE_DIR}"
