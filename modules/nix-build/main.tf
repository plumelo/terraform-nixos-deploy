terraform {
  required_providers {
    shell = {
      source  = "steigr/shell"
      version = "~> 1.8"
    }
  }
}

resource "shell_script" "build" {
  lifecycle_commands {
    create = "${path.module}/build.sh"
    delete = ""
  }
  environment = {
    ATTRIBUTE    = var.attribute
    ALLOW_UNFREE = tostring(var.allow_unfree)
  }
  triggers = var.triggers
}

output "out" {
  description = "Nix store output path"
  value       = shell_script.build.output["out"]
}