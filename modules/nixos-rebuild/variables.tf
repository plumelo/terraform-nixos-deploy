variable "attribute" {
  type        = string
  description = "Nix flake attribute to deploy (e.g. '.#nixosConfigurations.hostname')"
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

variable "forward_agent" {
  type        = bool
  default     = false
  description = "Enable SSH agent forwarding (-A) to the remote host."
}

variable "identity_agent" {
  type        = bool
  default     = true
  description = "Pin the SSH agent socket via -o IdentityAgent. Only takes effect when SSH_AUTH_SOCK is set in the environment."
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