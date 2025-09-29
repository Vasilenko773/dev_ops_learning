terraform {
  required_version = "~>1.8.4"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~>0.160"
    }
  }
}

variable "cloud_id" {}
variable "folder_id" {}
variable "network_zone" {}

resource "yandex_storage_bucket" "tf-state" {
  bucket    = "tf-state-bucket-for-state-storage"
  folder_id = var.folder_id
  anonymous_access_flags {
    read = false
    list = false
  }
  force_destroy = true
}