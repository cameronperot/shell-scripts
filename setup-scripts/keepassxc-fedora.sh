#!/usr/bin/env bash
set -euf -o pipefail

# More info at https://github.com/keepassxreboot/keepassxc

# Install required build packages
sudo dnf -y install \
  make \
  automake \
  gcc-c++ \
  cmake

# Install required dependencies
sudo dnf -y install \
  qt5-qtbase-devel \
  qt5-linguist \
  qt5-qttools \
  qt5-qtsvg-devel \
  qt5-qtx11extras \
  qt5-qtx11extras-devel \
  libgcrypt-devel \
  libargon2-devel \
  libsodium-devel \
  qrencode-devel \
  zlib-devel

# If the source direcory already exists delete it
source_dir=~/keepassxc
if [ -d $source_dir ]; then
  sudo rm -rf $source_dir
fi

# Download the source and prepare the build directory
cd ~
git clone https://github.com/keepassxreboot/keepassxc.git
cd keepassxc
git pull
git checkout master
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

# Delete the source directory
cd ~
sudo rm -rf $source_dir
