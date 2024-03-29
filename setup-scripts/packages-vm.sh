#!/usr/bin/env bash
set -eu -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P )"

# This script is for installing some useful packages on debian
if [ "$USER" != 'root' ]; then
	echo "You must run this script as root!"
	exit 1;
fi

apt-get update
apt-get -y upgrade
apt-get -y install \
	sudo \
	vim \
	firmware-linux-nonfree \
	dkms \
	htop \
	curl \
	iptables-persistent \
	build-essential \
	module-assistant \
	automake \
	libtool \
	ca-certificates \
	cmake \
	libqt4-dev \
	libgcrypt11-dev \
	zlib1g-dev \
	tmux
