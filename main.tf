module "deploy" {
  source = "./modules/nixos-deploy"

  attribute      = var.attribute
  target_host    = var.target_host
  target_user    = var.target_user
  sudo           = var.sudo
  forward_agent  = var.forward_agent
  identity_agent = var.identity_agent
  allow_unfree   = var.allow_unfree
  nix_options    = var.nix_options
  debug_logging  = var.debug_logging
  sops_file      = var.sops_file
  sops_key       = var.sops_key
  sops_dest      = var.sops_dest
  extra_triggers = var.extra_triggers
}