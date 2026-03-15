locals {
  # Parse attribute into flake_path and attr_name
  # Examples:
  #   ".#flow" → flake_path=".", attr_name="flow"
  #   "./formations/flow#flow" → flake_path="./formations/flow", attr_name="flow"
  #   ".#nixosConfigurations.flow" → flake_path=".", attr_name="nixosConfigurations.flow"
  parts      = split("#", var.attribute)
  flake_path = length(local.parts) > 1 ? local.parts[0] : "."
  attr_name  = length(local.parts) > 1 ? local.parts[1] : var.attribute

  # Extract hostname from attr_name:
  #   "nixosConfigurations.flow" → "flow"
  #   "flow" → "flow"
  hostname = coalesce(
    try(regex("nixosConfigurations\\.([^\\.]+)", local.attr_name)[0], null),
    local.attr_name
  )

  # Full attribute for nix-drv (derivation)
  drv_attribute = "${local.flake_path}#nixosConfigurations.${local.hostname}.config.system.build.toplevel"

  # Short attribute for nixos-rebuild --flake
  flake_attribute = "${local.flake_path}#${local.hostname}"
}

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
  attribute     = local.drv_attribute
  nix_options   = var.nix_options
  allow_unfree  = var.allow_unfree
  debug_logging = var.debug_logging
}

module "deploy" {
  source      = "../nixos-rebuild"
  attribute   = local.flake_attribute
  target_host = var.target_host
  target_user = var.target_user
  sudo        = var.sudo
  triggers = concat(
    [module.derivation.result.drv],
    var.sops_file != null ? [module.sops[0].id] : [],
    var.extra_triggers
  )
}