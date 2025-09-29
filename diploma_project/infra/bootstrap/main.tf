resource "yandex_iam_service_account" "k8s-service-account" {
  name        = "terraform-sa"
  description = "Сервисный аккаунт для Terraform"
}

# даем доступ к папке для создания всех ресурсов
resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.k8s-service-account.id}"
}

# создаем ключ сервисного аккаунта
resource "yandex_iam_service_account_key" "sa-key" {
  service_account_id = yandex_iam_service_account.k8s-service-account.id
  description        = "Создает ключ доступа у сервисного аккаунта"
}

# бакет для последующего хранения state в s3
resource "yandex_storage_bucket" "tf_state_bucket" {
  bucket = "tf-state-bucket-for-state-storage"
  folder_id = var.folder_id

  lifecycle {
    prevent_destroy = true
  }
}

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~>0.160"
    }
  }
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.network_zone
}