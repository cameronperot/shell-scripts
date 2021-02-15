#!/usr/bin/env bash
set -eu -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P)"

wget -O /tmp/juliamono-ttf.zip https://github.com/cormullion/juliamono/raw/master/juliamono-ttf.zip
unzip -d $HOME/.fonts/ /tmp/juliamono-ttf.zip
