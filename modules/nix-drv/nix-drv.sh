#!/usr/bin/env bash
set -efu

declare attribute nix_options allow_unfree debug_logging
eval "$(jq -r '@sh "attribute=\(.attribute) nix_options=\(.nix_options) allow_unfree=\(.allow_unfree) debug_logging=\(.debug_logging)"')"

if [ "${debug_logging}" = "true" ]; then
  set -x
fi

if [ "${nix_options}" != '{"options":{}}' ]; then
  options=$(echo "${nix_options}" | jq -r '.options | to_entries | map("--option \(.key) \(.value)") | join(" ")')
else
  options=""
fi

extra_flags=""
if [ "${allow_unfree}" = "true" ]; then
  export NIXPKGS_ALLOW_UNFREE=1
  extra_flags="--impure"
fi

out=$(nix path-info --json ${options} --derivation "$attribute" ${extra_flags})

printf '%s' "$out" | jq -c '.drv=keys[0]|{"drv"}'