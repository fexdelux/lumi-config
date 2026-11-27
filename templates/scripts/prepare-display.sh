#!/usr/bin/env bash

set -euo pipefail

LCD=""
OTHER=0

for attempt in $(seq 1 15); do
    LCD=""
    OTHER=0

    for fb in /sys/class/graphics/fb[0-9]*; do
        [ -r "$fb/name" ] || continue
        name=$(cat "$fb/name")
        if [ "$name" = "fb_ili9486" ]; then
            LCD="/dev/$(basename "$fb")"
        else
            OTHER=$((OTHER + 1))
        fi
    done

    [ -n "$LCD" ] && [ -c "$LCD" ] && break
    sleep 1
done

if [ -z "$LCD" ] || [ ! -c "$LCD" ]; then
    echo "LUMI: LCD nao encontrado."
    exit 1
fi

echo "LUMI: LCD detectado em $LCD"

if [ "$OTHER" -gt 0 ]; then
    echo "LUMI: Outro framebuffer presente."
    echo "LUMI: Console preservado."
    exit 0
fi

for vt in /sys/class/vtconsole/vtcon*; do
    [ -r "$vt/name" ] || continue
    if grep -qi "frame buffer" "$vt/name"; then
        if [ "$(cat "$vt/bind")" = "1" ]; then
            echo 0 > "$vt/bind"
        fi
        echo "LUMI: Console framebuffer liberado."
    fi
done
