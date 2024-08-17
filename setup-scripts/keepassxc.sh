#!/usr/bin/env bash
set -eu -o pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"

# More info at https://github.com/keepassxreboot/keepassxc
KEEPASSXC_VERSION="2.7.9"

# Install required dependencies
sudo dnf -y install \
    make \
    automake \
    botan2-devel \
    cmake \
    gcc-c++ \
    qt5-qtbase-devel \
    qt5-qtbase-private-devel \
    qt5-linguist \
    qt5-qttools \
    qt5-qtsvg-devel \
    qt5-qtx11extras \
    qt5-qtx11extras-devel \
    qt5ct \
    libgcrypt-devel \
    libargon2-devel \
    libsodium-devel \
    libXi-devel \
    libXtst-devel \
    minizip-ng-compat-devel \
    readline-devel \
    rubygem-asciidoctor \
    qrencode-devel \
    zlib-devel

# If the source direcory already exists delete it
SOURCE_DIR="/tmp/keepassxc"
sudo rm -rf "${SOURCE_DIR}"

# Download the source and prepare the build directory
git clone https://github.com/keepassxreboot/keepassxc.git "${SOURCE_DIR}"
cd "${SOURCE_DIR}"
git fetch
git pull
git checkout "${KEEPASSXC_VERSION}"
mkdir build
cd build

# Run cmake with the desired options
cmake \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DCMAKE_VERBOSE_MAKEFILE=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DWITH_XC_AUTOTYPE=ON \
    -DWITH_XC_YUBIKEY=OFF \
    -DWITH_XC_BROWSER=OFF \
    -DWITH_XC_NETWORKING=OFF \
    -DWITH_XC_SSHAGENT=OFF \
    -DWITH_XC_TOUCHID=OFF \
    -DWITH_XC_FDOSECRETS=OFF \
    -DWITH_XC_KEESHARE=OFF \
    -DWITH_XC_KEESHARE_SECURE=OFF \
    -DWITH_XC_ALL=OFF \
    -DWITH_XC_UPDATECHECK=OFF \
    -DWITH_TESTS=ON \
    -DWITH_GUI_TESTS=ON \
    -DWITH_DEV_BUILD=OFF \
    -DWITH_ASAN=OFF \
    -DWITH_COVERAGE=OFF \
    -DWITH_APP_BUNDLE=OFF \
    ..

# Install it to /usr/local/bin
sudo make install

# Remove the source directory
sudo rm -rf "${SOURCE_DIR}"
