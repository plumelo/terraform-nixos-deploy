# terraform-nixos-deploy

> nixtf — NixOS Terraform modules with plan-time change detection

Reusable Terraform modules for NixOS workflows. Published to the Terraform Registry as [`plumelo/deploy/nixos`](https://registry.terraform.io/modules/plumelo/deploy/nixos).

## Why nixtf?

Most NixOS Terraform modules run `nixos-rebuild` on every `terraform apply` — building the system closure and deploying it whether anything changed or not. `terraform plan` tells you nothing useful: you see "will run nixos-rebuild" regardless of whether the flake actually changed.

nixtf takes a different approach. It evaluates the Nix derivation **before** building:

1. **`nix-drv`** calls `nix eval` on every `terraform plan` — pure evaluation, no building, takes seconds. The derivation path (`/nix/store/xxx-myhost.drv`) is a content-addressed hash of every input to the system.
2. **`nix-build`** only runs if the derivation hash changed — meaning something in your flake actually differs. No change, no build. Minutes saved on every no-op plan.
3. **`nixos-rebuild`** only runs if a new build was produced — meaning the deploy is always intentional, never automatic.

The result: `terraform plan` is fast and meaningful. It tells you *which hosts need a rebuild* before you apply. You can run `terraform apply` on a schedule across a fleet without rebuilding every host every time. Plan output shows exactly which hosts changed — not just "I ran nixos-rebuild."

```
$ terraform plan
module.deploy.derivation: Refreshing state... [id=/nix/store/c3p...myhost.drv]
module.deploy: Drift detected (derivation changed: /nix/store/abc... → /nix/store/def...)

  # module.deploy will be replaced
- resource "terraform_data" "nixos_rebuild" { ... }

Plan: 1 to add, 1 to change, 0 to destroy.
```

Compare to a typical `nixos-rebuild`-on-apply module where every `terraform plan` says "will run nixos-rebuild" with no indication of whether anything actually changed.

## Quick Start

```hcl
module "deploy" {
  source      = "plumelo/deploy/nixos"
  version     = "1.0.0"
  attribute   = ".#nixosConfigurations.myhost"
  target_host = "192.168.1.100"
}
```

## Modules

### nixos-deploy (root)

All-in-one module that combines `nix-drv`, `nixos-rebuild`, and optionally `sops-deploy` into a single convenient module. This is the default entrypoint when using `source = "plumelo/deploy/nixos"`.

```hcl
module "deploy" {
  source         = "plumelo/deploy/nixos"
  version        = "1.0.0"
  attribute      = ".#nixosConfigurations.myhost"
  target_host    = "192.168.1.100"
  target_user    = "root"
  sudo           = false
  allow_unfree   = false
  sops_file      = "${path.module}/sops.yaml"
  extra_triggers = [var.instance.mac_address]
}
```

**Without sops (minimal):**

```hcl
module "deploy" {
  source      = "plumelo/deploy/nixos"
  version     = "1.0.0"
  attribute   = ".#nixosConfigurations.myhost"
  target_host = "192.168.1.100"
}
```

**Outputs:**
- `derivation` — Derivation information
- `sops_id` — Sops deploy resource ID (if sops enabled)

### nix-drv

Evaluates a Nix derivation hash without building. Runs on every `terraform plan` — fast, pure Nix evaluation.

Use this to detect when a Nix derivation has changed, triggering dependent resources.

```hcl
module "nix_drv" {
  source       = "plumelo/deploy/nixos//modules/nix-drv"
  version      = "1.0.0"
  attribute    = ".#nixosConfigurations.myhost"
  allow_unfree = false
}
```

**Outputs:**
- `result.drv` — The derivation path (e.g. `/nix/store/xxx-myhost.drv`)

### nix-build

Builds a Nix flake attribute and returns the output path. Triggered by derivation changes.

Uses `shell_script` from the `steigr/shell` provider to run `nix build` and capture the output.

```hcl
module "nix_build" {
  source       = "plumelo/deploy/nixos//modules/nix-build"
  version      = "1.0.0"
  attribute    = ".#nixosConfigurations.myhost.config.system.build.toplevel"
  allow_unfree = false
  triggers     = {
    drv = module.nix_drv.result.drv
  }
}
```

**Outputs:**
- `out` — The Nix store output path (e.g. `/nix/store/xxx-myhost`)

### nixos-rebuild

Runs `nixos-rebuild switch` against a remote host over SSH. Uses `--flake` to deploy the specified attribute.

```hcl
module "deploy" {
  source      = "plumelo/deploy/nixos//modules/nixos-rebuild"
  version     = "1.0.0"
  attribute   = ".#nixosConfigurations.myhost"
  target_host = "192.168.1.100"
  target_user = "root"
  sudo        = false
  triggers    = [module.nix_build.out]
}
```

### sops-deploy

Deploys sops-encrypted secrets to remote hosts over SSH.

```hcl
module "sops" {
  source   = "plumelo/deploy/nixos//modules/sops-deploy"
  version  = "1.0.0"
  host     = "192.168.1.100"
  user     = "root"
  path     = "${path.module}/secrets.yaml"
  key      = "[\"age\"][\"key\"]"
  dest     = "/var/lib/sops-nix/key.txt"
  triggers = [var.some_trigger]
}
```

**Outputs:**
- `id` — Resource ID for use as trigger in dependent resources

## Typical Workflow

### With nixos-deploy (recommended)

For most use cases, use the combined `nixos-deploy` module:

```hcl
module "deploy" {
  source         = "plumelo/deploy/nixos"
  version        = "1.0.0"
  attribute      = ".#nixosConfigurations.myhost"
  target_host    = var.target_host
  sops_file      = "${path.module}/sops.yaml"
  allow_unfree   = true
  extra_triggers = [var.instance.mac_address]
}
```

### With separate modules

Combine `nix-drv`, `nix-build`, and `nixos-rebuild` for a complete NixOS deployment pipeline:

```hcl
# 1. Evaluate derivation hash (runs on every plan)
module "nix_drv" {
  source    = "plumelo/deploy/nixos//modules/nix-drv"
  version   = "1.0.0"
  attribute = ".#nixosConfigurations.myhost"
}

# 2. Build when derivation changes
module "nix_build" {
  source    = "plumelo/deploy/nixos//modules/nix-build"
  version   = "1.0.0"
  attribute = ".#nixosConfigurations.myhost.config.system.build.toplevel"
  triggers  = { drv = module.nix_drv.result.drv }
}

# 3. Deploy when build changes
module "deploy" {
  source      = "plumelo/deploy/nixos//modules/nixos-rebuild"
  version     = "1.0.0"
  attribute   = ".#nixosConfigurations.myhost"
  target_host = var.target_host
  target_user = "admin"
  triggers    = [module.nix_build.out]
}
```

## Requirements

- **Terraform** >= 1.4
- **Nix** with flakes enabled on the machine running Terraform
- **jq** for JSON processing in shell scripts
- **SSH agent** running with deploy key loaded (for `nixos-rebuild`)
- **sops** CLI (for `sops-deploy`)
- Terraform providers:
  - `hashicorp/external` (for `nix-drv`, `nixos-rebuild`, `sops-deploy`)
  - `steigr/shell` (for `nix-build`)

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

## License

MIT