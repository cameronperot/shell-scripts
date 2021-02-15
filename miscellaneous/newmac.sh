#!/usr/bin/env bash
set -eu -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P)"

sudo ip link set dev wlp0s20f3 down

vendor_prefix=$(macchanger -l | grep "$1" | shuf -n 1 | awk '{print $3}')
random_suffix=$(echo $RANDOM | md5sum | sed 's/.\{2\}/&:/g' | cut -c 1-8)
new_mac="$vendor_prefix:$random_suffix"
sudo macchanger -m "$new_mac" "$2"

sudo ip link set dev wlp0s20f3 up
