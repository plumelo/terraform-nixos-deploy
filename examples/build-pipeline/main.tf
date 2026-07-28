terraform {
  required_version = ">= 1.4"

  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "~> 2.3"
    }
    shell = {
      source  = "steigr/shell"
      version = "~> 1.8"
    }
  }
}

# 1. Evaluate derivation hash (runs on every plan)
module "nix_drv" {
  source    = "plumelo/deploy/nixos//modules/nix-drv"
  version   = "1.0.1"
  attribute = ".#nixosConfigurations.myhost"
}

# 2. Build when derivation changes
module "nix_build" {
  source    = "plumelo/deploy/nixos//modules/nix-build"
  version   = "1.0.1"
  attribute = ".#nixosConfigurations.myhost.config.system.build.toplevel"
  triggers = {
    drv = module.nix_drv.result.drv
  }
}

# 3. Deploy when build changes
module "deploy" {
  source      = "plumelo/deploy/nixos//modules/nixos-rebuild"
  version     = "1.0.1"
  attribute   = ".#nixosConfigurations.myhost"
  target_host = var.target_host
  triggers    = [module.nix_build.out]
}

variable "target_host" {
  type        = string
  description = "IP or hostname of the target NixOS machine"
}