#!/usr/bin/env bash
set -eu -o pipefail

# More info at: https://github.com/rvaiya/keyd/issues/66

FILE_PATH="/usr/share/libinput/99-keyd-dwt.quirks"
echo "Creating ${FILE_PATH}..."
echo '[Serial Keyboards]
MatchUdevType=keyboard
MatchName=keyd*keyboard
AttrKeyboardIntegration=internal' | sudo tee "${FILE_PATH}"
echo "Created ${FILE_PATH}"
