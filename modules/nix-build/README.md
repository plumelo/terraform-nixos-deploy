# nix-build

Builds a Nix flake attribute and returns the output path. Triggered by derivation changes.

Uses `shell_script` from the `steigr/shell` provider to run `nix build` and capture the output.

## Example Usage

```hcl
module "nix_build" {
  source    = "plumelo/deploy/nixos//modules/nix-build"
  version   = "1.0.0"
  attribute = ".#nixosConfigurations.myhost.config.system.build.toplevel"
  triggers  = {
    drv = module.nix_drv.result.drv
  }
}
```

## Outputs

- `out` — The Nix store output path (e.g. `/nix/store/xxx-myhost`)