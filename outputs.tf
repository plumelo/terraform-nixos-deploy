output "derivation" {
  value       = module.deploy.derivation
  description = "Derivation information"
}

output "sops_id" {
  value       = module.deploy.sops_id
  description = "Sops deploy resource ID (if sops enabled)"
}