#!/usr/bin/env bash
set -eu -o pipefail

mkdir /tmp/adodefont
cd /tmp/adodefont
wget https://github.com/adobe-fonts/source-code-pro/archive/2.030R-ro/1.050R-it.tar.gz
tar -xvf ./1.050R-it.tar.gz
mkdir -p ~/.fonts
cp source-code-pro-2.030R-ro-1.050R-it/OTF/*.otf ~/.fonts/
fc-cache -f -v
