#!/usr/bin/env bash
set -eu -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P)"

# This script is for installing VirtualBox Guest Additions on Debian based distros
if [ "$USER" != 'root' ]; then
	echo "You must run this script as root!"
	exit 1;
fi

echo "Updating apt packages list..."
apt-get update

echo "Upgrading apt packages..."
apt-get -y upgrade

echo "Installing build-essential & module-assistant..."
apt-get -y install build-essential module-assistant

echo "Configuring system for building kernel modules..."
m-a prepare

echo "Making directory /root/VBoxGuestAdditions..."
mkdir /root/VBoxGuestAdditions

echo "Mounting Virtual Box Guest Additions ISO to /root/VBoxGuestAdditions..."
mount /dev/cdrom /root/VBoxGuestAdditions

echo "Moving to the mounted directory at /root/VBoxGuestAdditions..."
cd /root/VBoxGuestAdditions

echo "Running the provided VBoxLinuxAdditions installer..."
./VBoxLinuxAdditions.run
