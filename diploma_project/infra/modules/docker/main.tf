resource "yandex_container_registry" "my_registry" {
  name = "my-app-registry"
}

resource "yandex_iam_service_account_key" "registry_key" {
  service_account_id = var.service_account_id
}

terraform {
  required_version = "~>1.8.4"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~>0.160"
    }
  }
}