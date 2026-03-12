variable "host" {
  type        = string
  description = "Target host to connect to"
}

variable "user" {
  type        = string
  default     = "root"
  description = "SSH user to connect as"
}

variable "path" {
  type        = string
  description = "Path to sops-encrypted file"
}

variable "key" {
  type        = string
  description = "YAML key path to extract (e.g. '[\"age\"][\"key\"]')"
}

variable "dest" {
  type        = string
  default     = "/var/lib/sops-nix/key.txt"
  description = "Destination path on target host"
}

variable "triggers" {
  type        = list(string)
  default     = []
  description = "Additional triggers for secret replacement"
}