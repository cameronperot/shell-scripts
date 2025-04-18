#!/usr/bin/env bash
set -eu -o pipefail

echo "Starting i3status-rust installation..."

echo "Installing required dependencies..."
sudo dnf install -y \
    clang \
    gcc \
    git \
    lm_sensors-devel \
    notmuch-devel \
    openssl-devel \
    pipewire-devel \
    pulseaudio-libs-devel

SOURCE_DIR="/tmp/i3status-rust"
if [ -d "${SOURCE_DIR}" ]; then
    echo "Removing existing source directory: ${SOURCE_DIR}"
    sudo rm -rf "${SOURCE_DIR}"
fi

echo "Cloning i3status-rust repository..."
git clone https://github.com/greshake/i3status-rust "${SOURCE_DIR}"
cd "${SOURCE_DIR}"

echo "Building i3status-rust (this may take a few minutes)..."
. "${HOME}/.cargo/env"
cargo install --path . --locked

echo "Installing runtime files..."
./install.sh

echo "Cleaning up..."
cd ..
rm -rf "${SOURCE_DIR}"

echo "i3status-rust installation completed successfully!"
