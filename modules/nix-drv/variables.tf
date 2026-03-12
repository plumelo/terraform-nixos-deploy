variable "attribute" {
  type        = string
  description = "Nix flake attribute to evaluate (e.g. '.#package' or 'path:/abs/path#package')"
}

variable "nix_options" {
  type        = map(string)
  default     = {}
  description = "Extra Nix options to pass (e.g. { cores = \"4\" })"
}

variable "allow_unfree" {
  type        = bool
  default     = false
  description = "Allow unfree Nix packages (sets NIXPKGS_ALLOW_UNFREE=1 and --impure)"
}

variable "debug_logging" {
  type        = bool
  default     = false
  description = "Enable debug logging in the script"
}