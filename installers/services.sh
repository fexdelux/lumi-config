#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
[[ "$USER" =~ ^[a-z_][a-z0-9_-]*$ && "$HOME" =~ ^/[a-zA-Z0-9_/-]+$ ]] || exit 1
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
for file in "$ROOT"/templates/systemd/*; do
 name="$(basename "$file")"
 sed -e "s|@USER@|$USER|g" -e "s|@HOME@|$HOME|g" "$file" > "$tmp/$name"
 sudo install -m 0644 "$tmp/$name" "/etc/systemd/system/$name"
done
sudo install -d -m 0755 /usr/local/lib/lumi
sudo install -o root -g root -m 0755 "$ROOT/templates/scripts/prepare-display.sh" /usr/local/lib/lumi/prepare-display.sh
sudo systemctl daemon-reload
sudo systemctl enable --now lumi-messagebus.service lumi-core.service lumi-display.service lumi-weather.timer lumi-weather.path
# Real power operations remain disabled. Polkit template is opt-in.
