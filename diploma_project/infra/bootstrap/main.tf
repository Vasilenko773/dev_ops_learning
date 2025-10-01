variable "create_sa" {
  type    = bool
  default = true
}

variable "create_bucket" {
  type    = bool
  default = true
}

# Сервисный аккаунт (создаётся только если create_sa = true)
resource "yandex_iam_service_account" "k8s-service-account" {
  count       = var.create_sa ? 1 : 0
  name        = "terraform-sa"
  description = "Сервисный аккаунт для Terraform"
}

# Даем доступ к папке (создаётся только если SA создан)
resource "yandex_resourcemanager_folder_iam_member" "editor" {
  count     = var.create_sa ? 1 : 0
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.k8s-service-account[0].id}"
}

# Ключ сервисного аккаунта (создаётся только если SA создан)
resource "yandex_iam_service_account_key" "sa_key" {
  count              = var.create_sa ? 1 : 0
  service_account_id = yandex_iam_service_account.k8s-service-account[0].id
  description        = "Создает ключ доступа у сервисного аккаунта"
}

# Бакет S3 для state (создаётся только если create_bucket = true)
resource "yandex_storage_bucket" "tf_state_bucket" {
  count     = var.create_bucket ? 1 : 0
  bucket    = "tf-state-bucket-for-state-storage"
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