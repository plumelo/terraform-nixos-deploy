terraform {
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "~> 2.3"
    }
  }
}

locals {
  ssh_opts = join(" ", compact([
    var.forward_agent ? "-A" : "",
    var.identity_agent ? "$${SSH_AUTH_SOCK:+-o IdentityAgent=$SSH_AUTH_SOCK}" : "",
    "-o StrictHostKeyChecking=no",
    "-o UserKnownHostsFile=/dev/null",
  ]))
}

resource "terraform_data" "nixos_rebuild" {
  triggers_replace = var.triggers

  provisioner "local-exec" {
    command = <<-EOT
      NIX_SSHOPTS="${local.ssh_opts}" \
        nixos-rebuild switch --no-reexec --flake ${var.attribute} --target-host ${var.target_user}@${var.target_host}${var.sudo ? " --sudo" : ""}
    EOT
  }
}