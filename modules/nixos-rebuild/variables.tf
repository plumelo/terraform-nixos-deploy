variable "nixos_system" {
  type        = string
  description = "Nix derivation path for the NixOS system to deploy (e.g. '.#nixosConfigurations.hostname.config.system.build.toplevel')"
}

variable "target_host" {
  type        = string
  description = "The host to deploy to"
}

variable "target_user" {
  type        = string
  default     = "root"
  description = "User to deploy as"
}

variable "sudo" {
  type        = bool
  default     = false
  description = "Use sudo for remote commands"
}

variable "triggers" {
  type        = list(string)
  default     = []
  description = "Additional triggers that cause a rebuild"
}