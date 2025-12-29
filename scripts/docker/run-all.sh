#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SCRIPTS_DIR="${ROOT_DIR}/scripts/docker"

shopt -s nullglob

scripts=("${SCRIPTS_DIR}"/*.sh)
if [[ ${#scripts[@]} -eq 0 ]]; then
  echo "No docker scripts found in ${SCRIPTS_DIR}"
  exit 0
fi

for script in "${scripts[@]}"; do
  base="$(basename "$script")"
  if [[ "$base" == "run-all.sh" ]]; then
    continue
  fi

  echo
  echo "==> Running: scripts/docker/${base}"
  bash "$script"
done

