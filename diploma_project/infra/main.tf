terraform {
  required_version = "~>1.8.4"

  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

  backend "s3" {
    bucket    = "tf-state-bucket-for-state-storage"
    region    = "ru-central1"
    key       = "terraform.tfstate"
    profile   = "yc-s3"
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

provider "yandex" {
  service_account_key_file = "${path.module}/../sa-key.json"
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.network_zone
}


#module "service_account" {
#  source       = "./modules/service-account"
#  cloud_id     = var.cloud_id
#  folder_id    = var.folder_id
#  network_zone = var.network_zone
#}

#module "state-bucket" {
#  source       = "./modules/state-bucket"
#  cloud_id     = var.cloud_id
#  folder_id    = var.folder_id
#  network_zone = var.network_zone
#}