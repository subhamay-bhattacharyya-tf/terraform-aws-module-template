#!/usr/bin/env bash
set -euo pipefail

if command -v tfsec >/dev/null 2>&1; then
  tfsec .
  exit 0
fi

echo "tfsec not found. Install it or use CI workflow." >&2
exit 1

