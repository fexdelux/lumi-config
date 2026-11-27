#!/usr/bin/env bash
set -u
echo '===== LUMI doctor (read-only) ====='
uname -m
cat /etc/os-release
free -h
swapon --show
df -h /
for cmd in 'measure_temp' 'get_throttled'; do vcgencmd "$cmd" 2>/dev/null || true; done
for unit in lumi-messagebus lumi-core lumi-display lumi-weather.timer lumi-weather.path ollama; do
 printf '%s: ' "$unit"; systemctl is-active "$unit" || true
done
ls -l /dev/fb* /dev/snd/control* 2>/dev/null || true
echo "===== ALSA ====="
cat /proc/asound/pcm 2>/dev/null || true
aplay -l 2>/dev/null || true
arecord -l 2>/dev/null || true
udevadm --version 2>/dev/null || true
for card in /proc/asound/card[0-9]*/id; do
 [[ -r "$card" ]] || continue
 id="$(cat "$card")"
 amixer -c "$id" scontents 2>/dev/null || true
done
if [[ -d "$HOME/lumi" ]]; then
 (cd "$HOME/lumi" && /usr/bin/python3 -c 'from ui.providers.audio_selector import AudioSelector; print(AudioSelector().snapshot())') || echo "Diagnóstico de seleção indisponível; verifique configuração e versão."
fi
