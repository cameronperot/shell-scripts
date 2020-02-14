#!/usr/bin/env bash
set -eu -o pipefail

# This resetting the networking routes after disconnecting OpenVPN
if [ "$USER" != 'root' ]; then
	echo "You must run this script as root!"
	exit 1;
fi

echo "Resetting network routes..."
ip route flush table main
ip route add 10.0.2.0/24 dev enp0s3  proto kernel  scope link  src 10.0.2.15  metric 100
ip route add default via 10.0.2.2 dev enp0s3  proto static  metric 100
echo "Network routes have been reset!"
