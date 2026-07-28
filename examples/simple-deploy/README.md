# Simple Deploy

Deploys a single NixOS host using the root `nixos-deploy` module with minimal configuration.

## Prerequisites

- Nix with flakes enabled
- SSH agent running with deploy key loaded
- A NixOS flake with a `nixosConfigurations.myhost` attribute

## Usage

```hcl
terraform init
terraform apply
```

Set `target_host` to the IP or hostname of the remote NixOS machine.