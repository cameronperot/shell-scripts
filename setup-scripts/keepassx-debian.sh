#!/usr/bin/env bash
set -eu -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P)"

# This script is for installing KeePassX on Debian based distros
if [ "$USER" != 'root' ]; then
	echo "You must run this script as root!"
	exit 1;
fi

# Set environment variables
echo "Setting environment variables..."
KPX_VER="keepassx-2.0.3"
KPX_URL="https://www.keepassx.org/releases/2.0.3/keepassx-2.0.3.tar.gz"

# Update/upgrade packages
echo "Upgrading packages..."
apt-get update
apt-get -y upgrade

# Install required packages
echo "Installing required packages..."
apt-get install build-essential cmake libqt4-dev libgcrypt11-dev zlib1g-dev

# Download the latest keepassx and extract it
echo "Downloading, extracting, and installing KeePassX..."
wget -O $HOME/$KPX_VER.tar.gz $KPX_URL
cd $HOME
tar -xvf $HOME/$KPX_VER.tar.gz
cd $HOME/$KPX_VER

# Configure, make, and install keepassx
mkdir build
cd build
cmake ..
make && make install
cd $HOME

echo "KeePassX is now installed!"
