#!/usr/bin/env bash
set -euo pipefail

if ! command -v tflint >/dev/null 2>&1; then
  echo "tflint not found. Install it or run in devcontainer." >&2
  exit 1
fi

tflint --init
tflint -f compact

