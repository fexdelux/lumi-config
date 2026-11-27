# shellcheck shell=bash
fail(){ echo "$*" >&2; exit 1; }
require(){ command -v "$1" >/dev/null || fail "Ausente: $1"; }
pin(){ [[ "$1" =~ ^[0-9a-f]{40}$ ]] || fail 'Informe SHA Git completo e verificado.'; }
clone_pin(){
 local url="$1" dest="$2" ref="$3"
 pin "$ref"
 if [[ -e "$dest" ]]; then
  [[ -d "$dest/.git" ]] || fail "Diretório existente: $dest"
  [[ "$(git -C "$dest" rev-parse HEAD)" = "$ref" ]] || fail "Ref diferente: $dest"
  [[ -z "$(git -C "$dest" status --porcelain --untracked-files=no)" ]] || fail "Alterações locais: $dest"
 else
  git clone --no-checkout "$url" "$dest"
  git -C "$dest" checkout --detach "$ref"
 fi
}
preflight(){
 [[ "$(uname -m)" = aarch64 ]] || fail 'ARM64 necessário.'
 grep -q '^VERSION_ID="13"' /etc/os-release || fail 'Debian 13 necessário.'
 [[ -r /proc/device-tree/model ]] && grep -aq 'Raspberry Pi 3 Model B' /proc/device-tree/model || fail 'Hardware fora da baseline.'
 require sudo; require git; require vcgencmd
 [[ "$(vcgencmd get_throttled)" = throttled=0x0 ]] || fail 'Alimentação: resolva subtensão/throttling antes da instalação.'
 pin "${LUMI_REF:-}"; pin "${LCD_REF:-}"
 [[ -n "${UV_VERSION:-}" ]] || fail 'Versão uv não registrada.'
 [[ -x "$HOME/.local/bin/uv" ]] || fail 'Instale previamente uv verificado (docs/installation.md).'
 [[ "$("$HOME/.local/bin/uv" --version | awk '{print $2}')" = "$UV_VERSION" ]] || fail 'Versão uv diferente.'
 for f in "${BUS_LOCK:-}" "${CORE_LOCK:-}" "${CONSTRAINTS:-}"; do [[ -n "$f" && -f "$f" ]] || fail 'Locks homologados ausentes.'; done
 if [[ -e "$HOME/lumi" || -e "$HOME/LCD-show" || -e "$HOME/.venvs/ovos" || -e "$HOME/.venvs/ovos312" || -e /etc/systemd/system/lumi-display.service ]]; then
  [[ "${ALLOW_EXISTING:-no}" = yes ]] || fail 'Instalação existente: faça backup; ALLOW_EXISTING=yes somente após revisão.'
 fi
 if [[ ! -x /usr/local/bin/ollama ]] && ! command -v ollama >/dev/null; then
  [[ -f "${OLLAMA_INSTALLER:-}" && "${OLLAMA_INSTALLER_SHA256:-}" =~ ^[0-9a-f]{64}$ ]] || fail 'Instalador Ollama revisado e checksum necessários.'
  printf '%s  %s\n' "$OLLAMA_INSTALLER_SHA256" "$OLLAMA_INSTALLER" | sha256sum -c -
 fi
}
system(){ mapfile -t packages < "$ROOT/manifests/apt-packages.txt"; sudo apt-get update; sudo apt-get install -y "${packages[@]}"; sudo usermod -aG audio,video,input "$USER"; }
memory(){ bash "$ROOT/installers/memory.sh"; }
python(){
 local uv="$HOME/.local/bin/uv"
 mkdir -p "$HOME/.venvs"
 [[ -x "$HOME/.venvs/ovos/bin/python" ]] || /usr/bin/python3 -m venv "$HOME/.venvs/ovos"
 "$uv" python install "$PYTHON312_VERSION"
 [[ -x "$HOME/.venvs/ovos312/bin/python" ]] || "$uv" venv --python "$PYTHON312_VERSION" "$HOME/.venvs/ovos312"
}
lcd(){
 clone_pin https://github.com/fexdelux/LCD-show.git "$HOME/LCD-show" "$LCD_REF"
 echo 'Driver clonado. Execute a instalação homologada LCD35-lite-show conforme docs/lcd.md; reinício e calibração são etapas manuais.'
 [[ -c /dev/fb1 && -s "$HOME/lumi-touch.json" ]] || fail 'LCD/calibração pendentes; retome após homologação.'
}
ollama(){
 if ! command -v ollama >/dev/null; then bash "$OLLAMA_INSTALLER"; fi
 ollama --version | grep -F "$OLLAMA_VERSION" || fail 'Versão Ollama diferente.'
 sudo install -d /etc/systemd/system/ollama.service.d
 sudo install -m 0644 "$ROOT/templates/ollama/lumi.conf" /etc/systemd/system/ollama.service.d/lumi.conf
 sudo systemctl daemon-reload
 sudo systemctl enable --now ollama
 sudo systemctl restart ollama
 ollama pull qwen2.5:0.5b
 ollama pull smollm2:135m-instruct-q4_0
}
openvoiceos(){
 local uv="$HOME/.local/bin/uv"
 "$uv" pip install --python "$HOME/.venvs/ovos/bin/python" -r "$BUS_LOCK"
 "$uv" pip install --python "$HOME/.venvs/ovos312/bin/python" -c "$CONSTRAINTS" -r "$CORE_LOCK"
 "$uv" pip check --python "$HOME/.venvs/ovos/bin/python"
 "$uv" pip check --python "$HOME/.venvs/ovos312/bin/python"
 mkdir -p "$HOME/.config/mycroft"
 if [[ ! -e "$HOME/.config/mycroft/mycroft.conf" ]]; then cp "$ROOT/templates/openvoiceos/mycroft.conf" "$HOME/.config/mycroft/mycroft.conf"; fi
}
lumi(){
 clone_pin https://github.com/fexdelux/lumi.git "$HOME/lumi" "$LUMI_REF"
 mkdir -p "$HOME/lumi/"{config,cache,logs}
 local uv="$HOME/.local/bin/uv"
 for skill in lumi-identity lumi-fallback; do "$uv" pip install --python "$HOME/.venvs/ovos312/bin/python" --no-deps -e "$HOME/lumi/skills/$skill"; done
 for name in display weather; do
  [[ -e "$HOME/lumi/config/$name.json" ]] || cp "$ROOT/templates/display/$name.json" "$HOME/lumi/config/$name.json"
 done
 touch "$HOME/lumi/cache/weather.request"
}
data(){ (cd "$HOME/lumi/data/import" && sha256sum -c SHA256SUMS); /usr/bin/python3 "$HOME/lumi/scripts/import-municipios.py"; }
services(){ bash "$ROOT/installers/services.sh"; }
validation(){ bash "$ROOT/doctor.sh"; }
