output "id" {
  value       = terraform_data.deploy.id
  description = "Resource ID for use as trigger in dependent resources"
}