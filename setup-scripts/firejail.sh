#!/bin/bash
set -e

cd ~
git clone https://github.com/netblue30/firejail.git
cd firejail
./configure
make
sudo make install-strip
cd ~
rm -rf ~/firejail
