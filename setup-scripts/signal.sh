#!/usr/bin/env bash
set -eu -o pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"

SIGNAL_VERSION="v7.17.0"
NODE_VERSION="20.15.0"

podman run \
    --rm \
    -it \
    -v "${HOME}/bin:/app:z" \
    -e SIGNAL_VERSION=${SIGNAL_VERSION} \
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
    cat package.json | jq '.build.linux += {target:["deb","AppImage"]}' > with_appimage_package.json
    mv with_appimage_package.json package.json
    YARNCLEAN_PATH=/usr/local/share/.config/yarn/global
    mkdir -p $YARNCLEAN_PATH
    cp .yarnclean $YARNCLEAN_PATH/.yarnclean
    yarn --c
    yarn install --frozen-lockfile
    yarn build-release
    ls -la ./release
    cp ./release/Signal-*.AppImage /app/
    uid=$(ls -nd /app | awk '{ print $3 }')
    gid=$(ls -nd /app | awk '{ print $4 }')
    chown $uid:$gid /app/Signal-*.AppImage
EOF
    )"
