# nix-drv

Evaluates a Nix derivation hash without building. Runs on every `terraform plan` — fast, pure Nix evaluation.

Use this to detect when a Nix derivation has changed, triggering dependent resources.

## Example Usage

```hcl
module "nix_drv" {
  source    = "plumelo/deploy/nixos//modules/nix-drv"
  version   = "1.0.0"
  attribute = ".#nixosConfigurations.myhost"
}
```

## Outputs

- `result.drv` — The derivation path (e.g. `/nix/store/xxx-myhost.drv`)