#!/usr/bin/env bash
set -eu -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P )"

SOURCE_DIR="/tmp/keyd"
sudo rm -rf "${SOURCE_DIR}"

git clone https://github.com/rvaiya/keyd "${SOURCE_DIR}"
cd "${SOURCE_DIR}"
make
sudo make install

echo '[ids]

*

[main]

# Maps capslock to escape when pressed and control when held.
rightcontrol = rightcontrol
capslock = overload(control, esc)

# Remaps the escape key to capslock
esc = capslock' | sudo tee /etc/keyd/default.conf

sudo systemctl enable keyd
sudo systemctl start keyd

sudo rm -rf "${SOURCE_DIR}"
