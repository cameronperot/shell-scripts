#!/usr/bin/env bash
set -eu -o pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"

VBoxManage controlvm "XandorasBox Clone" pause || echo "Could not pause"
sleep 10s

export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/"$(id -u "$LOGNAME")"/bus
systemd-run --user systemctl suspend
