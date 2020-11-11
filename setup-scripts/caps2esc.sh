#!/usr/bin/env bash
set -e

sudo dnf install cmake yaml-cpp-devel libevdev-devel systemd-devel
cd $HOME
rm -rf caps2esc
mkdir caps2esc
cd caps2esc

git clone https://gitlab.com/interception/linux/plugins/caps2esc.git
cd caps2esc
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

cd $HOME/caps2esc

git clone https://gitlab.com/interception/linux/tools.git
cd tools
mkdir build
cd build
cmake ..
make
sudo make install

sudo systemctl enable --now udevmon
sudo systemctl status  udevmon
