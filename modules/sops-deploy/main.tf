terraform {
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "~> 2.3"
    }
  }
}

locals {
  dest_folder = dirname(var.dest)
}

resource "terraform_data" "deploy" {
  triggers_replace = concat([
    var.user,
    var.host
  ], var.triggers)

  connection {
    type = "ssh"
    user = var.user
    host = var.host
  }

  provisioner "remote-exec" {
    inline = [
      "[ -d ${local.dest_folder} ] || mkdir -p ${local.dest_folder}",
    ]
  }

  provisioner "local-exec" {
    command = <<-EOT
      [ -d ${path.module}/${self.id} ] || mkdir -p ${path.module}/${self.id}
      sops --extract '${var.key}' -d ${var.path} > ${path.module}/${self.id}/key.txt
    EOT
  }

  provisioner "file" {
    source      = "${path.module}/${self.id}/key.txt"
    destination = var.dest
  }

  provisioner "local-exec" {
    command = "rm -rf ${path.module}/${self.id}"
  }
}