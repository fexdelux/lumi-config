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
amixer -c Headphones sget PCM 2>/dev/null || true
amixer -c Device sget Mic 2>/dev/null || true
