#!/usr/bin/env bash
set -eu -o pipefail

# Set the correct permissions for the ~/.ssh directory
SSH_DIR="${HOME}/.ssh"
echo "Updating permissions for ${SSH_DIR}"
mkdir -p "${SSH_DIR}"
chmod 700 "${SSH_DIR}"
find "${SSH_DIR}" -type f -name "*.pub" -exec chmod 644 {} \;
find "${SSH_DIR}" -type f ! -name "*.pub" -exec chmod 600 {} \;
chown -R "${USER}:${USER}" "${SSH_DIR}"
echo "Updated permissions for ${SSH_DIR}"
