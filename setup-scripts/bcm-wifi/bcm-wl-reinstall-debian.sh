#!/bin/bash	
# This script is for reinstalling the bcm wl driver
if [ "$USER" != 'root' ]; then
	echo "You must run this script as root!"
	exit 1;
fi

# Create working directory
rm -r ~/bcm_wl/
mkdir ~/bcm_wl
cd ~/bcm_wl/
cp /home/user/rsync/nix/source/hybrid-v35_64-nodebug-pcoem-6_30_223_271.tar.gz ./

if [ 'x86_64' == `uname -m` ]; then
	# 64-bit driver files.
	FILE='hybrid-v35_64-nodebug-pcoem-6_30_223_271.tar.gz'
else
	# 32-bit driver files.
	FILE='hybrid-v35-nodebug-pcoem-6_30_223_271.tar.gz'
fi

# Extract the source
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
