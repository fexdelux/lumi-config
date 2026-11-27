#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
for file in install.sh doctor.sh installers/*.sh tests/*.sh; do bash -n "$file"; done
bash install.sh --dry-run
python3 -m json.tool templates/openvoiceos/mycroft.conf >/dev/null
python3 -m json.tool templates/display/display.json >/dev/null
python3 -m json.tool templates/display/weather.json >/dev/null
echo 'Smoke estático OK; não valida hardware nem instalação.'
