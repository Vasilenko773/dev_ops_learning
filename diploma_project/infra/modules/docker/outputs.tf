output "my_registry_endpoint" {
  description = "Yandex Container Registry endpoint for docker push"
  value       = "cr.yandex/${yandex_container_registry.my_registry.id}"
}

output "registry_sa_private_key" {
  description = "Private key for the registry service account"
  value       = yandex_iam_service_account_key.registry_key.private_key
  sensitive   = true
}