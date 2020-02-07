#!/usr/bin/env bash
set -euf -o pipefail

cd ~
git clone https://github.com/kitsunyan/intel-undervolt.git
cd intel-undervolt
./configure --enable-systemd
make
sudo make install
cd ~
rm -rf ~/intel-undervolt
