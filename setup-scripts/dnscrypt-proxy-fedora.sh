#!/usr/bin/env bash
set -euf -o pipefail

# This script is for installing the latest dnscrypt-proxy on RHEL/Fedora based distros
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
dnf -y upgrade

# Install required packages
echo "Installing required packages..."
dnf -y install fakeroot make automake gcc gcc-c++ libtool ca-certificates curl libsodium-devel

# Install libsodium from source
if [ "$1" == "true" ]; then
    # Download the latest libsodium and extract it
    echo "Downloading, extracting, and installing the latest libsodium..."
    wget -O ~/libsodium.tar.gz $LIBS_URL
    cd ~/
    tar -xvf ~/libsodium.tar.gz
    cd ~/libsodium-*

    # Configure, make, and install libsodium
    ./configure
    make && make install
    echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
    ldconfig
fi

# Download the latest dnscrypt-proxy and extract it
echo "Downloading, extracting, and installing the latest dnscrypt-proxy..."
wget -O ~/dnscrypt-proxy.tar.gz $DNSC_URL
cd ~/
tar -xvf ~/dnscrypt-proxy.tar.gz
cd ~/dnscrypt-*

# Configure, make, and install dnscrypt-proxy
./configure
make
make install

echo "dnscrypt-proxy is now installed!"
