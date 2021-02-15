#!/usr/bin/env bash
set -eu -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P)"

SOURCE_DIR=/tmp/adodefont
rm -rf $SOURCE_DIR
mkdir $SOURCE_DIR

cd $SOURCE_DIR
wget https://github.com/adobe-fonts/source-code-pro/archive/2.030R-ro/1.050R-it.tar.gz
tar -xvf ./1.050R-it.tar.gz
mkdir -p $HOME/.fonts
cp source-code-pro-2.030R-ro-1.050R-it/OTF/*.otf $HOME/.fonts/
fc-cache -f -v
