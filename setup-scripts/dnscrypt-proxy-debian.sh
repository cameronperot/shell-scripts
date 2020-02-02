#!/bin/bash
set -e

# This script is for installing the latest dnscrypt-proxy on Debian based distros
if [ "$USER" != 'root' ]; then
	echo "You must run this script as root!"
	exit 1;
fi

# Set environment variables
echo "Setting environment variables..."
DNSC_URL="https://download.dnscrypt.org/dnscrypt-proxy/LATEST.tar.gz"
LIBS_URL="https://download.libsodium.org/libsodium/releases/LATEST.tar.gz"

# Update/upgrade packages
echo "Upgrading packages..."
apt-get update
apt-get -y upgrade

# Install required packages
echo "Installing required packages..."
apt-get -y install build-essential automake libtool ca-certificates

# Download the latest libsodium and extract it
echo "Downloading, extracting, and installing the latest libsodium..."
wget -O ~/libsodium.tar.gz $LIBS_URL
cd ~/
tar -xvf ~/libsodium.tar.gz
cd ~/libsodium-*

# Configure, make, and install libsodium
./configure
make && make install
ldconfig

# Download the latest dnscrypt-proxy and extract it
echo "Downloading, extracting, and installing the latest dnscrypt-proxy..."
wget -O ~/dnscrypt-proxy.tar.gz $DNSC_URL
cd ~/
tar -xvf ~/dnscrypt-proxy.tar.gz
cd ~/dnscrypt-*

# Configure, make, and install dnscrypt-proxy
./configure
make && make install
cd ~

echo "dnscrypt-proxy is now installed!"
