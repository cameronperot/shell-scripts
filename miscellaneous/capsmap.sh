#!/usr/bin/env bash
set -eu -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P )"

/usr/bin/setxkbmap -option 'caps:ctrl_modifier'
$HOME/bin/xcape/xcape -e 'Caps_Lock=Escape' -t 100
