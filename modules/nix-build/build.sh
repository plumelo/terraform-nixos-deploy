#!/usr/bin/env bash
set -euo pipefail

: "${ATTRIBUTE:?Need to set ATTRIBUTE}"

extra_flags=""
if [ "${ALLOW_UNFREE}" = "true" ]; then
  export NIXPKGS_ALLOW_UNFREE=1
  extra_flags="--impure"
fi

out=$(nix build --no-link --print-out-paths ${extra_flags} "$ATTRIBUTE")

echo "{\"out\": \"$out\"}"