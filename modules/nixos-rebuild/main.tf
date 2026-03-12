terraform {
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "~> 2.3"
    }
  }
}

resource "terraform_data" "nixos_rebuild" {
  triggers_replace = concat([
    var.nixos_system,
  ], var.triggers)

  provisioner "local-exec" {
    command = <<-EOT
      NIX_SSHOPTS="-A -o IdentityAgent=$SSH_AUTH_SOCK -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" \
        nixos-rebuild switch --no-reexec -f ${var.nixos_system} --target-host ${var.target_user}@${var.target_host}${var.sudo ? " --sudo" : ""}
    EOT
  }
}