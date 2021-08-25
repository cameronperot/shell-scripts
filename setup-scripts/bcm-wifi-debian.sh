#!/usr/bin/env bash
set -eu -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P )"

# This script is for installing the bcm wl driver
if [ "$USER" != 'root' ]; then
	echo "You must run this script as root!"
	exit 1
fi

source_dir=/tmp/bcm_wifi

# Install required packages
apt-get update
apt-get install -y dkms module-assistant build-essential

# Check if directory already exists, if so delete it
if [ -d "$source_dir" ]; then
	rm -rf "$source_dir"
fi

# Create working directory
mkdir "$source_dir"
cd "$source_dir"

FILE='hybrid-v35_64-nodebug-pcoem-6_30_223_271.tar.gz'

# Download & extract the source

if [ "$1" == "download" ]; then
	wget https://docs.broadcom.com/docs-and-downloads/docs/linux_sta/$FILE
else
	cp ./$FILE ./
fi

tar xvzf $FILE

# Compile & install the driver
make clean && make
make install

# Update available drivers
depmod -a

# Unload conflicting drivers
rmmod b43 ssb bcma

# Load the driver
modprobe wl

# Blacklist conflicting drivers
printf 'blacklist b43\nblacklist ssb\nblacklist bcma\n' | tee /etc/modprobe.d/wl.conf

# Load driver automatically at boot time
echo 'wl' | tee /etc/modules-load.d/wl.conf
