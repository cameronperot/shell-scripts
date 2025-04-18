#!/usr/bin/env bash
set -eu -o pipefail

echo "Starting Miniconda installation..."

INSTALL_DIR="${1:-${HOME}/miniconda3}"
CONDA_URL=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
echo "Installation directory set to: ${INSTALL_DIR}"
if [ -d "${INSTALL_DIR}" ]; then
    echo "Removing existing install directory: ${INSTALL_DIR}"
    sudo rm -rf "${INSTALL_DIR}"
fi

echo "Creating fresh installation directory..."
mkdir "${INSTALL_DIR}"
cd "${INSTALL_DIR}"

echo "Downloading Miniconda installer..."
wget -O miniconda.sh "${CONDA_URL}"

echo "Running Miniconda installer..."
bash miniconda.sh -b -f -p "${INSTALL_DIR}"
rm -f miniconda.sh

echo "Updating conda to the latest version..."
export PATH="${INSTALL_DIR}/bin:${PATH}"
conda update -y conda

echo "Miniconda installation completed successfully!"
