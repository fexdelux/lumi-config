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
(cd manifests/locks && sha256sum -c SHA256SUMS)
python3 - <<'PY'
import re
from pathlib import Path
for name, count in [('bus.txt', 34), ('core.txt', 71)]:
    lines = Path('manifests/locks', name).read_text().splitlines()
    assert len(lines) == count, name
    assert all(re.fullmatch(r'[A-Za-z0-9_.-]+==[A-Za-z0-9_.!+~-]+', line) for line in lines), name
    names = [re.sub(r'[-_.]+', '-', line.split('==')[0]).lower() for line in lines]
    assert len(set(names)) == count, name
    assert not any(n.startswith('lumi-skill-') for n in names), name
    print(f'{name}: {count} pinned packages OK')
PY
grep -Fxq 'StartLimitIntervalSec=60s' templates/systemd/lumi-weather.service
grep -Fxq 'StartLimitBurst=20' templates/systemd/lumi-weather.service
grep -Fxq 'TriggerLimitIntervalSec=60s' templates/systemd/lumi-weather.path
grep -Fxq 'TriggerLimitBurst=10' templates/systemd/lumi-weather.path
grep -Fxq 'OnCalendar=*-*-* *:0/5:00' templates/systemd/lumi-weather.timer
/usr/bin/python3 scripts/verify-artifacts.py --manifest-only
echo 'Smoke estático OK; não valida hardware nem instalação.'
