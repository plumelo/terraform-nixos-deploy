terraform {
  required_version = ">= 1.4"

  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "~> 2.3"
    }
  }
}

module "deploy" {
  source      = "plumelo/deploy/nixos"
  version     = "1.0.0"
  attribute   = ".#nixosConfigurations.myhost"
  target_host = var.target_host
  sops_file   = "${path.module}/sops.yaml"
}

variable "target_host" {
  type        = string
  description = "IP or hostname of the target NixOS machine"
}