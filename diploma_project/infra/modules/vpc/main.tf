terraform {
  required_version = "~>1.8.4"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~>0.160"
    }
  }
}

resource "yandex_vpc_network" "vpc" {
  name      = "k8s-vpc"
  folder_id = var.folder_id
}

resource "yandex_vpc_subnet" "subnets" {
  for_each = { for s in var.subnets : s.name => s }

  name           = each.value.name
  zone           = each.value.zone
  network_id     = yandex_vpc_network.vpc.id
  folder_id      = var.folder_id
  v4_cidr_blocks = [each.value.cidr]
}
