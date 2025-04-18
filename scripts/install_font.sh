#!/usr/bin/env bash
set -eu -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P )"

FONTS_DIR="${HOME}/.fonts"

if [ ! -d "${FONTS_DIR}" ]; then
    mkdir -p "${FONTS_DIR}"
fi

wget -O /tmp/font.zip "${1}"
unzip -o -d "${FONTS_DIR}/" /tmp/font.zip
fc-cache -f -v
rm /tmp/font.zip
