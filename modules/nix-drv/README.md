# nix-drv

Evaluates a Nix derivation hash without building. Runs on every `terraform plan` — fast, pure Nix evaluation.

This is the core of what makes nixtf different from typical NixOS Terraform modules. Instead of building on every `terraform apply`, `nix-drv` calls `nix eval` to compute the derivation path. The path is a content-addressed hash — if nothing in your flake changed, the hash is identical and downstream modules (`nix-build`, `nixos-rebuild`) don't run at all. If something did change, Terraform shows the diff at plan time, and only then does the build + deploy fire.

## Example Usage

```hcl
module "nix_drv" {
  source    = "plumelo/deploy/nixos//modules/nix-drv"
  version   = "1.0.1"
  attribute = ".#nixosConfigurations.myhost"
}
```

## Outputs

- `result.drv` — The derivation path (e.g. `/nix/store/xxx-myhost.drv`)