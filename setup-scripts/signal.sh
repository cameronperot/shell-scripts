#!/usr/bin/env bash
set -eu -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd -P)"

podman run --rm -it -v $HOME/bin:/app:z -w /app node:12.13.0 bash -c "$(cat << 'EOF'
    set -euo pipefail
    git clone --branch=master --depth=1 https://github.com/signalapp/Signal-Desktop.git /tmp/Signal-Desktop
    cd /tmp/Signal-Desktop
    npm install -g json && json -I -f package.json -e "this.build.linux.target[0] = 'appimage'"
    yarn install
    yarn build-release
    cp /tmp/Signal-Desktop/release/Signal-*.AppImage /app/
    uid=$(ls -nd /app | awk '{ print $3 }')
    gid=$(ls -nd /app | awk '{ print $4 }')
    chown $uid:$gid /app/Signal-*.AppImage
EOF
)"
