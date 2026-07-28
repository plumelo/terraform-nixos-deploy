# Build Pipeline

Deploys a NixOS host using the separate `nix-drv`, `nix-build`, and `nixos-rebuild` modules for a complete deployment pipeline with explicit control over each stage.

## Prerequisites

- Nix with flakes enabled
- SSH agent running with deploy key loaded
- A NixOS flake with a `nixosConfigurations.myhost` attribute

## Usage

```hcl
terraform init
terraform apply
```

The pipeline runs in three stages:

1. **nix-drv** — Evaluates the derivation hash (runs on every `plan`)
2. **nix-build** — Builds the toplevel when the derivation changes
3. **nixos-rebuild** — Deploys when the build output changes