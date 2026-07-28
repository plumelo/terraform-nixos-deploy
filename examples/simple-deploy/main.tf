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
  version     = "1.0.1"
  attribute   = ".#nixosConfigurations.myhost"
  target_host = var.target_host
}

variable "target_host" {
  type        = string
  description = "IP or hostname of the target NixOS machine"
}