#!/usr/bin/env bash
set -eu -o pipefail

echo "Starting keyd installation..."

SOURCE_DIR="/tmp/keyd"
if [ -d "${SOURCE_DIR}" ]; then
    echo "Removing existing source directory: ${SOURCE_DIR}"
    sudo rm -rf "${SOURCE_DIR}"
fi

echo "Cloning keyd repository..."
git clone https://github.com/rvaiya/keyd "${SOURCE_DIR}"
cd "${SOURCE_DIR}"

echo "Building keyd..."
make

echo "Installing keyd..."
sudo make install

echo "Creating keyd configuration file..."
echo '[ids]

*

[main]

# Maps capslock to escape when pressed and control when held.
rightcontrol = rightcontrol
capslock = overload(control, esc)

# Remaps the escape key to capslock
esc = capslock' | sudo tee /etc/keyd/default.conf

echo "Enabling keyd service to start on boot..."
sudo systemctl enable keyd

echo "Starting keyd service..."
sudo systemctl start keyd

echo "Cleaning up source directory..."
sudo rm -rf "${SOURCE_DIR}"

echo "keyd installation completed successfully!"
