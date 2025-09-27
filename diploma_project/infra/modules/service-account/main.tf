#variable "cloud_id" {}
#variable "folder_id" {}
#variable "network_zone" {}
#
#resource "yandex_iam_service_account" "k8s-service-account" {
#  name        = "terraform-sa"
#  description = "Сервисный акаунт для k8s кластера"
#}
#
#resource "yandex_resourcemanager_folder_iam_member" "service-account-editor" {
#  folder_id = var.folder_id
#  role      = "editor"
#  member    = "serviceAccount:${yandex_iam_service_account.k8s-service-account.id}"
#}
#
#resource "yandex_iam_service_account_key" "sa-key" {
#  service_account_id = yandex_iam_service_account.k8s-service-account.id
#  description        = "Создает ключ доступа у сервисного аккаунта"
#}