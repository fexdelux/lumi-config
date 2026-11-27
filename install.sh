#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"
steps=(preflight system memory python lcd ollama openvoiceos lumi data services validation)
usage(){ echo "bash install.sh --dry-run | --apply | --only STEP | --status"; }
mode="${1:---dry-run}"
case "$mode" in
 --dry-run) printf 'Etapas previstas: %s\n' "${steps[*]}"; echo 'Nenhuma alteração. Leia docs/installation.md.'; exit 0;;
 --status) bash "$ROOT/doctor.sh"; exit;;
 --apply) [[ $# = 1 ]] || exit 2;;
 --only) [[ $# = 2 ]] || exit 2; [[ " ${steps[*]} " == *" $2 "* ]] || exit 2; steps=("$2");;
 *) usage; exit 2;;
esac
[[ $EUID != 0 ]] || { echo 'Execute como usuário normal com sudo.' >&2; exit 1; }
[[ -f "$ROOT/local.env" ]] || { echo 'Preencha local.env conforme o manifesto.' >&2; exit 1; }
# local.env is trusted shell input maintained by the operator.
source "$ROOT/local.env"
: "${BUS_LOCK:=$ROOT/manifests/locks/bus.txt}"
: "${CORE_LOCK:=$ROOT/manifests/locks/core.txt}"
: "${CONSTRAINTS:=$ROOT/manifests/locks/constraints-stable.txt}"
export ROOT
source "$ROOT/installers/common.sh"
preflight
for step in "${steps[@]}"; do
 echo "===== $step ====="
 "$step"
done
echo 'Etapas concluídas. Verifique doctor.sh e faça homologação física.'
