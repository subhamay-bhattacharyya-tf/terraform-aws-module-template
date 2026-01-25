#!/usr/bin/env bash
set -euo pipefail

if ! command -v terraform-docs >/dev/null 2>&1; then
  echo "terraform-docs not found. Install it or run in devcontainer." >&2
  exit 1
fi

terraform-docs .

