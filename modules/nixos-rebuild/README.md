# nixos-rebuild

Runs `nixos-rebuild switch` against a remote host over SSH. Uses `--flake` to deploy the specified attribute.

## Example Usage

```hcl
module "deploy" {
  source      = "plumelo/deploy/nixos//modules/nixos-rebuild"
  version     = "1.0.1"
  attribute   = ".#nixosConfigurations.myhost"
  target_host = "192.168.1.100"
  target_user = "root"
  triggers    = [module.nix_build.out]
}
```