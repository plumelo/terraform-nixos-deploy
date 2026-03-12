variable "attribute" {
  type        = string
  description = "Nix flake attribute to build (e.g. '.#package' or 'path:/abs/path#package')"
}

variable "triggers" {
  type        = map(string)
  default     = null
  description = "Triggers that cause a rebuild (typically { drv = module.nix_drv.result.drv })"
}

variable "allow_unfree" {
  type        = bool
  default     = false
  description = "Allow unfree Nix packages (sets NIXPKGS_ALLOW_UNFREE=1 and --impure)"
}