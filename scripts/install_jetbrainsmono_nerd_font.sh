#!/usr/bin/env bash
set -eu -o pipefail

echo "Starting JetBrainsMono Nerd Font installation..."

FONTS_DIR="${HOME}/.fonts"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip"
TMP_FILE="/tmp/font.zip"

if [ ! -d "${FONTS_DIR}" ]; then
    echo "Creating fonts directory..."
    mkdir -p "${FONTS_DIR}"
fi

echo "Downloading JetBrainsMono Nerd Font..."
wget -q --show-progress -O "${TMP_FILE}" "${FONT_URL}"

echo "Extracting font files to ${FONTS_DIR}..."
unzip -o -q -d "${FONTS_DIR}/" "${TMP_FILE}"

echo "Updating font cache..."
fc-cache -f

echo "Cleaning up temporary files..."
rm "${TMP_FILE}"

echo "JetBrainsMono Nerd Font installation completed successfully!"
