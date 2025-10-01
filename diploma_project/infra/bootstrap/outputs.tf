output "terraform_sa_id" {
  description = "ID сервисного аккаунта Terraform (если создан)"
  value       = var.create_sa ? yandex_iam_service_account.k8s-service-account[0].id : ""
  sensitive   = true
}

output "sa_private_key" {
  description = "Приватный ключ сервисного аккаунта (если создан)"
  value       = var.create_sa ? yandex_iam_service_account_key.sa_key[0].private_key : ""
  sensitive   = true
}

output "tf_state_bucket" {
  description = "Имя S3-бакета для Terraform state (если создан)"
  value       = var.create_bucket ? yandex_storage_bucket.tf_state_bucket[0].bucket : ""
}
