# Deploy with Sops Secrets

Deploys a NixOS host and syncs sops-encrypted secrets using the root `nixos-deploy` module with `sops_file` set.

## Prerequisites

- Nix with flakes enabled
- SSH agent running with deploy key loaded
- sops CLI installed
- A NixOS flake with a `nixosConfigurations.myhost` attribute
- A sops-encrypted `sops.yaml` file containing an age key

## Usage

```hcl
terraform init
terraform apply
```

The sops file should have a structure like:

```yaml
age:
    key: ENC[AES256_GCM,data:...]
```

The module extracts the key via `sops --extract '["age"]["key"]' -d sops.yaml` and deploys it to `/var/lib/sops-nix/key.txt` on the target host.