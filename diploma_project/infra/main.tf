terraform {
  required_version = "~>1.8.4"

  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

  backend "s3" {
    bucket                  = "tf-state-bucket-for-state-storage"
    region                  = "ru-central1"
    key                     = "terraform.tfstate"
    shared_credentials_file = "~/.terraform/credential.txt"
    profile                 = "terraform"
    endpoints               = {
      s3 = "https://storage.yandexcloud.net"
    }
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

provider "yandex" {
  service_account_key_file = "${path.module}/bootstrap/sa-key.json"
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.network_zone
}

module "vpc" {
  source    = "./modules/vpc"
  cloud_id  = var.cloud_id
  folder_id = var.folder_id

  network_name = "my-vpc"
  subnets      = [
    { name = "subnet-a", zone = "ru-central1-a", cidr = "10.0.1.0/24" },
    { name = "subnet-b", zone = "ru-central1-b", cidr = "10.0.2.0/24" },
  ]
}