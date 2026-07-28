# nixos-deploy

All-in-one module that combines `nix-drv`, `nixos-rebuild`, and optionally `sops-deploy` into a single convenient module.

Unlike typical NixOS Terraform modules that build on every `terraform apply`, nixtf evaluates the derivation at plan time via `nix-drv`. The build and deploy only fire when the derivation hash actually changes — so `terraform plan` tells you which hosts need a rebuild, and `terraform apply` only rebuilds what changed.

## Example Usage

**With sops:**

```hcl
module "deploy" {
  source         = "plumelo/deploy/nixos//modules/nixos-deploy"
  version        = "1.0.1"
  attribute      = ".#nixosConfigurations.myhost"
  target_host    = "192.168.1.100"
  sops_file      = "${path.module}/sops.yaml"
  allow_unfree   = true
  extra_triggers = [var.instance.mac_address]
}
```

**Without sops (minimal):**

```hcl
module "deploy" {
  source      = "plumelo/deploy/nixos//modules/nixos-deploy"
  version     = "1.0.1"
  attribute   = ".#nixosConfigurations.myhost"
  target_host = "192.168.1.100"
}
```

## Outputs

- `derivation` — Derivation information
- `sops_id` — Sops deploy resource ID (if sops enabled)