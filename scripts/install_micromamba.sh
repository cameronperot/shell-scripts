#!/usr/bin/env bash
set -eu -o pipefail

# Set variables
export MAMBA_ROOT_PREFIX="${HOME}/.micromamba"
MICROMAMBA="${MAMBA_ROOT_PREFIX}/bin/micromamba"
mkdir -p "${MAMBA_ROOT_PREFIX}"

# Check if already installed
if [ -x "${MICROMAMBA}" ]; then
    echo "micromamba is already installed at ${MAMBA_ROOT_PREFIX}"
    exit 0
fi

# Download and install micromamba
echo "Downloading and installing micromamba..."
curl -L "https://micro.mamba.pm/api/micromamba/linux-64/latest" | tar -xj -C "${MAMBA_ROOT_PREFIX}" bin/micromamba
chmod +x "${MICROMAMBA}"
eval "$("${MICROMAMBA}" shell hook -s bash)"
