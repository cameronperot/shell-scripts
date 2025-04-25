#!/usr/bin/env bash
set -eu -o pipefail

SIGNAL_VERSION="v7.52.0"
NODE_VERSION="22.14.0"
PNPM_VERSION="10.3.0"

podman run \
    --rm \
    -it \
    -v "${HOME}/bin:/app:z" \
    -e SIGNAL_VERSION=${SIGNAL_VERSION} \
    -e PNPM_VERSION=${PNPM_VERSION} \
    -w /tmp \
    node:${NODE_VERSION} \
    bash -c "$(
        cat <<'EOF'
    set -euo pipefail
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash
    apt-get update
    apt-get install -y jq git-lfs
    git clone --depth=1 --branch=$SIGNAL_VERSION https://github.com/signalapp/Signal-Desktop.git
    cd Signal-Desktop
    rm -f patches/socks-proxy-agent*
    sed 's#"node": "#&>=#' -i package.json
    cat package.json | jq '.build.linux += {target:["deb","AppImage"]}' > with_appimage_package.json
    mv with_appimage_package.json package.json
    npm install -g pnpm@$PNPM_VERSION
    pnpm install --frozen-lockfile
    pnpm run clean-transpile
    cd sticker-creator
    pnpm install --frozen-lockfile
    pnpm run build
    cd ..
    pnpm run generate
    pnpm run build-linux
    ls -la ./release
    cp ./release/Signal-*.AppImage /app/
    uid=$(ls -nd /app | awk '{ print $3 }')
    gid=$(ls -nd /app | awk '{ print $4 }')
    chown $uid:$gid /app/Signal-*.AppImage
EOF
    )"
