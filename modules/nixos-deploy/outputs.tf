output "derivation" {
  value       = module.derivation.result
  description = "Derivation information"
}

output "sops_id" {
  value       = var.sops_file != null ? module.sops[0].id : null
  description = "Sops deploy resource ID (if sops enabled)"
}