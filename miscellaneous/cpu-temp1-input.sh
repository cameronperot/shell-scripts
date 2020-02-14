#!/usr/bin/env bash
set -eu -o pipefail

PATH_5=/sys/devices/platform/coretemp.0/hwmon/hwmon5/temp1_input
PATH_6=/sys/devices/platform/coretemp.0/hwmon/hwmon6/temp1_input
PATH_TEMP=/tmp/cpu_temp1_input

if [ -f "$PATH_5" ]; then
    ln -s $PATH_5 $PATH_TEMP
elif [ -f "$PATH_6" ]; then
    ln -s $PATH_6 $PATH_TEMP
fi
