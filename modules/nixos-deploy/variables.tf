variable "attribute" {
  type        = string
  description = "Nix flake attribute. Accepts '.#flow', './path#flow', or '.#nixosConfigurations.flow' - both formats work."
}

variable "target_host" {
  type        = string
  description = "Target host IP or hostname"
}

variable "target_user" {
  type        = string
  default     = "root"
  description = "SSH user for deployment"
}

variable "sudo" {
  type        = bool
  default     = false
  description = "Use sudo for remote commands"
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

variable "allow_unfree" {
  type        = bool
  default     = false
  description = "Allow unfree Nix packages"
}

variable "nix_options" {
  type        = map(string)
  default     = {}
  description = "Extra Nix options"
}

variable "debug_logging" {
  type        = bool
  default     = false
  description = "Enable debug logging"
}

variable "sops_file" {
  type        = string
  default     = null
  description = "Path to sops file (enables sops-deploy when set)"
}

variable "sops_key" {
  type        = string
  default     = "[\"age\"][\"key\"]"
  description = "YAML key to extract from sops file"
}

variable "sops_dest" {
  type        = string
  default     = "/var/lib/sops-nix/key.txt"
  description = "Destination path for sops key on target"
}

variable "extra_triggers" {
  type        = list(string)
  default     = []
  description = "Additional triggers for rebuild"
}