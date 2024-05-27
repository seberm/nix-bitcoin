#!/usr/bin/env bash
set -euo pipefail
. "${BASH_SOURCE[0]%/*}/../helper/run-in-nix-env" "" "$@"

cd "${BASH_SOURCE[0]%/*}/.."

# Run deadnix over all nix files in this repo
deadnix --fail --exclude examples/ .
