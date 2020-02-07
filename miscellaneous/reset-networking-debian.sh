#!/usr/bin/env bash
set -euf -o pipefail

# This resetting the networking routes after disconnecting OpenVPN
if [ "$USER" != 'root' ]; then
	echo "You must run this script as root!"
	exit 1;
fi

echo "Resetting network routes..."
ifdown eth0
ip route flush table main
ifup eth0
ip route add 192.168.1.0/24 dev eth0  proto kernel  scope link  src 192.168.1.116
# ip route add default via 192.168.1.1 dev eth0
echo "Network routes have been reset!"
