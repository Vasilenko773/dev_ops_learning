# Таргет-группа для балансировщика
resource "yandex_lb_target_group" "lamp_tg" {
  name      = "lamp-target-group"
  folder_id = var.folder_id

  dynamic "target" {
    for_each = yandex_compute_instance_group.lamp_group.instances
    content {
      subnet_id = target.value.network_interface[0].subnet_id
      address   = target.value.network_interface[0].ip_address
    }
  }
}


# Сетевой балансировщик
resource "yandex_lb_network_load_balancer" "lamp_nlb" {
  name      = "lamp-nlb"
  folder_id = var.folder_id
  type      = "external"

  listener {
    name        = "http-listener"
    port        = 80
    target_port = 80
    protocol    = "tcp"
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.lamp_tg.id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}

output "nlb_ip_addresses" {
  value = flatten([
  for l in yandex_lb_network_load_balancer.lamp_nlb.listener : [
  for a in l.external_address_spec : a.address
  ]
  ])
}