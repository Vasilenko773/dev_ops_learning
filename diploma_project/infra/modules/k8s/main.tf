terraform {
  required_version = "~>1.8.4"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~>0.160"
    }
  }
}

resource "yandex_kubernetes_cluster" "this" {
  name       = "my-k8s-cluster"
  network_id = var.network_id
  folder_id  = var.folder_id

  master {
    version = var.k8s_version
    regional {
      region = "ru-central1"
      location {
        zone      = "ru-central1-a"
        subnet_id = var.subnet_ids[0]
      }
      location {
        zone      = "ru-central1-b"
        subnet_id = var.subnet_ids[1]
      }
      location {
        zone      = "ru-central1-d"
        subnet_id = var.subnet_ids[2]
      }
    }
    public_ip = true
  }

  service_account_id      = var.service_account_id
  node_service_account_id = var.service_account_id
  release_channel         = "REGULAR"
}

resource "yandex_kubernetes_node_group" "ng_a" {
  cluster_id = yandex_kubernetes_cluster.this.id
  name       = "ng-a"

  instance_template {
    platform_id = var.node_platform_id
    resources {
      cores  = var.node_cores
      memory = var.node_memory
    }
    boot_disk {
      type = "network-hdd"
      size = 40
    }
    network_interface {
      subnet_ids = [var.subnet_a_id]
      nat        = true
    }
  }

  scale_policy {
    auto_scale {
      min     = var.node_min_hosts
      max     = var.node_max_hosts
      initial = var.node_min_hosts
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }
}

resource "yandex_kubernetes_node_group" "ng_b" {
  cluster_id = yandex_kubernetes_cluster.this.id
  name       = "ng-b"

  instance_template {
    platform_id = var.node_platform_id
    resources {
      cores  = var.node_cores
      memory = var.node_memory
    }
    boot_disk {
      type = "network-hdd"
      size = 40
    }
    network_interface {
      subnet_ids = [var.subnet_b_id]
      nat        = true
    }
  }

  scale_policy {
    auto_scale {
      min     = var.node_min_hosts
      max     = var.node_max_hosts
      initial = var.node_min_hosts
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-b"
    }
  }
}

resource "yandex_kubernetes_node_group" "ng_d" {
  cluster_id = yandex_kubernetes_cluster.this.id
  name       = "ng-d"

  instance_template {
    platform_id = var.node_platform_id
    resources {
      cores  = var.node_cores
      memory = var.node_memory
    }
    boot_disk {
      type = "network-hdd"
      size = 40
    }
    network_interface {
      subnet_ids = [var.subnet_d_id]
      nat        = true
    }
  }

  scale_policy {
    auto_scale {
      min     = var.node_min_hosts
      max     = var.node_max_hosts
      initial = var.node_min_hosts
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-d"
    }
  }
}
