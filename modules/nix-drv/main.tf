terraform {
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "~> 2.3"
    }
  }
}

locals {
  nix_options = jsonencode({
    options = { for k, v in var.nix_options : k => v }
  })
}

data "external" "nix_drv" {
  program = ["bash", "${path.module}/nix-drv.sh"]
  query = {
    attribute     = var.attribute
    nix_options   = local.nix_options
    allow_unfree  = tostring(var.allow_unfree)
    debug_logging = tostring(var.debug_logging)
  }
}

output "result" {
  value = data.external.nix_drv.result
}