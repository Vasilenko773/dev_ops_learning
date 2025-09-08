# Сервисный аккаунт для Instance Group
resource "yandex_iam_service_account" "vm_sa" {
  name      = "lamp-sa"
  folder_id = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "sa_subnet_access" {
  folder_id = var.folder_id
  member    = "serviceAccount:${yandex_iam_service_account.vm_sa.id}"
  role      = "editor"
}

# Шаблон ОС
data "yandex_compute_image" "lamp" {
  family = var.vm_os
}

# Instance Group
resource "yandex_compute_instance_group" "lamp_group" {
  name               = "lamp-group"
  folder_id          = var.folder_id
  service_account_id = yandex_iam_service_account.vm_sa.id


  instance_template {
    platform_id = "standard-v3"

    resources {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }

    boot_disk {
      initialize_params {
        image_id = data.yandex_compute_image.lamp.id
      }
    }

    network_interface {
      subnet_ids         = [yandex_vpc_subnet.sub_network_public.id]
      nat                = true
      security_group_ids = [yandex_vpc_security_group.default_sg.id]
    }

    metadata = {
      serial-port-enable = true
      ssh-keys           = "ubuntu:${file(var.ssh_key_path)}"
      user-data = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: false
    runcmd:
      - apt-get update -y
      - apt-get install -y apache2
      - systemctl enable apache2
      - systemctl start apache2
    write_files:
      - path: /var/www/html/index.html
        content: |
          <html>
            <head><title>My DevOps Page</title></head>
            <body>
              <h1>Hello from LAMP</h1>
              <img src="https://${yandex_storage_bucket.my_bucket.bucket}.storage.yandexcloud.net/${yandex_storage_object.my_image.key}" alt="DevOps Logo" width="400">
            </body>
          </html>
  EOF
    }
  }

  allocation_policy {
    zones = [var.network_zone]
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  health_check {
    http_options {
      port = 80
      path = "/"
    }
  }
}
