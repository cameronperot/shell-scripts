#!/usr/bin/env bash
set -eu -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P)"

log_file=/home/user/vpnreconnect.log
time=`date +"%D %T"`

if ping -q -c 1 -W 1 1.1.1.1 >/dev/null; then
	echo "[$time] VPN is connected" >> "$log_file"
else
	echo "[$time] Restarting VPN" >> "$log_file"
	systemctl restart openvpn-client@<CONFIG_NAME>.service
fi
