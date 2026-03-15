module "sops" {
  count  = var.sops_file != null ? 1 : 0
  source = "../sops-deploy"

  host     = var.target_host
  user     = var.target_user
  path     = var.sops_file
  key      = var.sops_key
  dest     = var.sops_dest
  triggers = var.extra_triggers
}

module "derivation" {
  source        = "../nix-drv"
  attribute     = "${var.attribute}.config.system.build.toplevel"
  nix_options   = var.nix_options
  allow_unfree  = var.allow_unfree
  debug_logging = var.debug_logging
}

module "deploy" {
  source      = "../nixos-rebuild"
  attribute   = var.attribute
  target_host = var.target_host
  target_user = var.target_user
  sudo        = var.sudo
  triggers = concat(
    [module.derivation.result.drv],
    var.sops_file != null ? [module.sops[0].id] : [],
    var.extra_triggers
  )
}