# nixtf

Reusable Terraform modules for NixOS workflows.

## Modules

### nix-drv

Evaluates a Nix derivation hash without building. Runs on every `terraform plan` — fast, pure Nix evaluation.

Use this to detect when a Nix derivation has changed, triggering dependent resources.

```hcl
module "nix_drv" {
  source       = "git::https://github.com/plumelo/nixtf.git//modules/nix-drv?ref=v0.1.0"
  attribute    = ".#nixosConfigurations.myhost"
  allow_unfree = false  # optional, defaults to false
}
```

**Outputs:**
- `result.drv` — The derivation path (e.g. `/nix/store/xxx-myhost.drv`)

### nix-build

Builds a Nix flake attribute and returns the output path. Triggered by derivation changes.

Uses `shell_script` from the `steigr/shell` provider to run `nix build` and capture the output.

```hcl
module "nix_build" {
  source       = "git::https://github.com/plumelo/nixtf.git//modules/nix-build?ref=v0.1.0"
  attribute    = ".#nixosConfigurations.myhost.config.system.build.toplevel"
  allow_unfree = false  # optional, defaults to false
  triggers     = {
    drv = module.nix_drv.result.drv  # rebuild when derivation changes
  }
}
```

**Outputs:**
- `out` — The Nix store output path (e.g. `/nix/store/xxx-myhost`)

### nixos-rebuild

Runs `nixos-rebuild switch` against a remote host over SSH. Triggered by derivation changes.

```hcl
module "deploy" {
  source       = "git::https://github.com/plumelo/nixtf.git//modules/nixos-rebuild?ref=v0.1.0"
  nixos_system = module.nix_build.out
  target_host  = "192.168.1.100"
  target_user  = "root"  # optional, defaults to "root"
  sudo         = false   # optional, defaults to false
  triggers     = [module.nix_build.out]  # rebuild when NixOS system changes
}
```

## Typical Workflow

Combine all three modules for a complete NixOS deployment pipeline:

```hcl
# 1. Evaluate derivation hash (runs on every plan)
module "nix_drv" {
  source    = "git::https://github.com/plumelo/nixtf.git//modules/nix-drv?ref=v0.1.0"
  attribute = ".#nixosConfigurations.myhost"
}

# 2. Build when derivation changes
module "nix_build" {
  source    = "git::https://github.com/plumelo/nixtf.git//modules/nix-build?ref=v0.1.0"
  attribute = ".#nixosConfigurations.myhost.config.system.build.toplevel"
  triggers  = { drv = module.nix_drv.result.drv }
}

# 3. Deploy when build changes
module "deploy" {
  source       = "git::https://github.com/plumelo/nixtf.git//modules/nixos-rebuild?ref=v0.1.0"
  nixos_system = module.nix_build.out
  target_host  = var.target_host
  target_user  = "admin"
}
```

## Requirements

- **Nix** with flakes enabled on the machine running Terraform
- **jq** for JSON processing in shell scripts
- **SSH agent** running with deploy key loaded (for `nixos-rebuild`)
- Terraform providers:
  - `hashicorp/external` (for `nix-drv`, `nixos-rebuild`)
  - `steigr/shell` (for `nix-build`)

## License

MIT