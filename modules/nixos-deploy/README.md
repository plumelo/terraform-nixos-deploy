# nixos-deploy

All-in-one module that combines `nix-drv`, `nixos-rebuild`, and optionally `sops-deploy` into a single convenient module.

## Example Usage

**With sops:**

```hcl
module "deploy" {
  source         = "plumelo/deploy/nixos//modules/nixos-deploy"
  version        = "1.0.0"
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
  version     = "1.0.0"
  attribute   = ".#nixosConfigurations.myhost"
  target_host = "192.168.1.100"
}
```

## Outputs

- `derivation` — Derivation information
- `sops_id` — Sops deploy resource ID (if sops enabled)