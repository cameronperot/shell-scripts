#!/usr/bin/env bash
set -eu -o pipefail

# create service file
mkdir -p ~/.config/systemd/user/
cat >"${HOME}/.config/systemd/user/kanshi.service" <<'EOF'
[Unit]
Description=Dynamic output configuration for Wayland compositors
Documentation=https://sr.ht/~emersion/kanshi
BindsTo=sway-session.target

[Service]
Type=simple
ExecStart=/usr/bin/kanshi

[Install]
WantedBy=sway-session.target
EOF

# enable and start the service
systemctl --user daemon-reload
systemctl --user enable kanshi.service
systemctl --user start kanshi.service
systemctl --user status kanshi.service
