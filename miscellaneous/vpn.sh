#!/usr/bin/env bash
set -e

if [ "$1" == "" ]; then
	echo "Error: usage must be: vpn <action> <location"
	echo "First positional argument must be the action"
	echo "Second positional argument must be the VPN location"
	exit 1
fi
	

sudo systemctl "$1" openvpn-client@"$2".service
