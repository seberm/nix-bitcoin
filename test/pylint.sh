#!/usr/bin/env bash
set -euo pipefail
. "${BASH_SOURCE[0]%/*}/../helper/run-in-nix-env" "pylint" "$@"

cd "${BASH_SOURCE[0]%/*}/.."

# Pylint the Python scripts
pylint './test/tests.py'
