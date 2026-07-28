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