#!/usr/bin/env bash
set -eu -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P )"

SOURCE_DIR=/tmp/caps2esc
sudo rm -rf ${SOURCE_DIR}

sudo dnf install -y cmake libevdev-devel systemd-devel yaml-cpp-devel boost-devel

git clone https://gitlab.com/interception/linux/plugins/caps2esc.git ${SOURCE_DIR}
cd ${SOURCE_DIR}
mkdir build
cd build
cmake ..
make
sudo make install

echo '- JOB: "intercept -g $DEVNODE | caps2esc | uinput -d $DEVNODE"
  DEVICE:
    EVENTS:
      EV_KEY: [KEY_CAPSLOCK, KEY_ESC]'| sudo tee /etc/udevmon.yaml

echo '[Unit]
Description=udevmon
Wants=systemd-udev-settle.service
After=systemd-udev-settle.service

[Service]
ExecStart=/usr/bin/nice -n -20 /usr/local/bin/udevmon -c /etc/udevmon.yaml

[Install]
WantedBy=multi-user.target' | sudo tee /etc/systemd/system/udevmon.service

cd ${SOURCE_DIR}

git clone https://gitlab.com/interception/linux/tools.git
cd tools
mkdir build
cd build
cmake ..
make
sudo make install

sudo systemctl enable --now udevmon
sudo systemctl status  udevmon

sudo rm -rf ${SOURCE_DIR}
