#!/usr/bin/env bash
set -euo pipefail
# Never replace an existing swap or edit fstab blindly.
if ! swapon --show=NAME --noheadings | grep -Fxq /dev/zram0; then
 echo 'Configure ZRAM conforme docs/memory.md e retome.' >&2; exit 1
fi
if ! swapon --show=NAME --noheadings | grep -Fxq /swapfile-lumi; then
 echo 'Swap de disco pendente; siga docs/memory.md.' >&2; exit 1
fi
sudo sysctl -w vm.swappiness=60
printf 'vm.swappiness=60\n' | sudo tee /etc/sysctl.d/90-lumi-memory.conf >/dev/null
