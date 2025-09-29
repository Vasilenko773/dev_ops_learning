output "terraform_sa_id" {
  description = "ID сервисного аккаунта terraform-sa"
  value       = yandex_iam_service_account.k8s-service-account.id
}