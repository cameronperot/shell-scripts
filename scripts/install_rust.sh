#!/usr/bin/env bash
set -eu -o pipefail

echo "Starting rust installation..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
. "${HOME}/.cargo/env"
cargo install \
    mdbook \
    stylua \
    tree-sitter-cli
echo "Rust installation completed successfully!"
