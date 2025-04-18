#!/usr/bin/env bash
set -eu -o pipefail

echo "Starting intel-undervolt installation..."

SOURCE_DIR="/tmp/intel-undervolt"
if [ -d "${SOURCE_DIR}" ]; then
    echo "Removing existing source directory: ${SOURCE_DIR}"
    sudo rm -rf "${SOURCE_DIR}"
fi

echo "Cloning intel-undervolt repository..."
git clone https://github.com/kitsunyan/intel-undervolt.git "${SOURCE_DIR}"
cd "${SOURCE_DIR}"

echo "Configuring intel-undervolt with systemd support..."
./configure --enable-systemd

echo "Building intel-undervolt..."
make

echo "Installing intel-undervolt..."
sudo make install

echo "Applying undervolt settings..."
sudo intel-undervolt apply

echo "Reading current undervolt settings for verification..."
sudo intel-undervolt read

echo "Enabling intel-undervolt service to start on boot..."
sudo systemctl enable intel-undervolt.service

echo "Cleaning up source directory..."
sudo rm -rf "${SOURCE_DIR}"

echo "intel-undervolt installation completed successfully!"
