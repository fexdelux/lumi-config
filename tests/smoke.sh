#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
for file in install.sh doctor.sh installers/*.sh tests/*.sh templates/scripts/*.sh; do bash -n "$file"; done
bash install.sh --dry-run
python3 -m json.tool templates/openvoiceos/mycroft.conf >/dev/null
python3 -m json.tool templates/display/display.json >/dev/null
python3 -m json.tool templates/display/weather.json >/dev/null
python3 -m json.tool templates/display/audio.json >/dev/null
grep -Fq 'Requires=lumi-messagebus.service lumi-display-prepare.service' templates/systemd/lumi-display.service
grep -Fq 'ExecStart=/usr/local/lib/lumi/prepare-display.sh' templates/systemd/lumi-display-prepare.service
echo 'Smoke estático OK; não valida hardware nem instalação.'
