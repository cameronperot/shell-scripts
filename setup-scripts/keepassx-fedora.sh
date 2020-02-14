#!/usr/bin/env bash
set -eu -o pipefail

# This script is for installing KeePassX on Fedora/RHEL based distros
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Set environment variables
echo "Setting environment variables..."
KPX_VER="keepassx-2.0.3"
KPX_URL="https://www.keepassx.org/releases/2.0.3/keepassx-2.0.3.tar.gz"

# Update/upgrade packages
echo "Upgrading packages..."
dnf -y upgrade

# Install required packages
echo "Installing required packages..."
dnf -y install qt4-devel libXtst-devel cmake libgcrypt-devel gcc-c++

# Download the latest keepassx and extract it
echo "Downloading, extracting, and installing KeePassX..."
wget -O ~/$KPX_VER.tar.gz $KPX_URL
cd ~
tar -xvf ~/$KPX_VER.tar.gz
cd ~/$KPX_VER

# Configure, make, and install keepassx
mkdir build
cd build
cmake ..
make && make install
cd ~

echo "KeePassX is now installed!"
