terraform {
  required_version = "~>1.8.4"

  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "~>0.160"
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
    { name = "subnet-d", zone = "ru-central1-d", cidr = "10.0.3.0/24" },
  ]
}

module "k8s" {
  source     = "./modules/k8s"
  folder_id  = var.folder_id
  network_id = module.vpc.vpc_id
  subnet_ids = [module.vpc.subnet_a_id, module.vpc.subnet_b_id, module.vpc.subnet_d_id]

  k8s_version       = "1.30"
  node_platform_id  = "standard-v3"
  node_memory       = 4
  node_cores        = 2
  node_min_hosts    = 1
  node_max_hosts    = 3
  zones             = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]

  # сервисный аккаунт, который мы создали для k8s (он нужен обязательно!)
  service_account_id = var.terraform_sa_id
  node_service_account_id = var.terraform_sa_id
}



