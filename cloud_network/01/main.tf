resource "yandex_vpc_network" "network" {
  name = var.network_name
}
resource "yandex_vpc_subnet" "sub_network" {
  name           = var.network_name
  zone           = var.network_zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = var.network_cidr
}

## Public подсеть

resource "yandex_vpc_network" "network_public" {
  name = "network-task2"
}
### Tаблица марщрутизации
resource "yandex_vpc_route_table" "route_public_table" {
  name       = "public-rt"
  network_id = yandex_vpc_network.network_public.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.igw.id
  }
}


resource "yandex_vpc_subnet" "sub_network_public" {
  name           = "public"
  zone           = var.network_zone
  network_id     = yandex_vpc_network.network_public.id
  v4_cidr_blocks = var.public_network_cidr
  route_table_id = yandex_vpc_route_table.route_public_table.id
}

### Internet Gateway
resource "yandex_vpc_gateway" "igw" {
  name = "internet-gateway"
  shared_egress_gateway {}
}

### Security Group с SSH + ICMP
resource "yandex_vpc_security_group" "default_sg" {
  name       = "allow-ssh-icmp"
  network_id = yandex_vpc_network.network_public.id

  # SSH inbound
  ingress {
    protocol       = "TCP"
    description    = "Allow SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  # ICMP inbound (ping)
  ingress {
    protocol       = "ICMP"
    description    = "Allow ping"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound any
  egress {
    protocol       = "ANY"
    description    = "Allow all outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

data "yandex_compute_image" "os" {
  family = var.vm_os
}


### Виртуальная машина для подсети
resource "yandex_compute_instance" "vm_public" {
  name        = "public-vm"
  platform_id = "standard-v3"  # или любой другой

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.os.image_id
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.sub_network_public.id
    nat                = true  # включаем автопубличный IP
    security_group_ids = [yandex_vpc_security_group.default_sg.id]
  }


  metadata = {
    serial-port-enable = true
    ssh-keys           = "${var.ssh_user}:${file(var.ssh_key_path)}"
  }
}


### PRIVATE SUBNET

# Приватная подсеть
resource "yandex_vpc_subnet" "sub_network_private" {
  name           = "private"
  zone           = var.network_zone
  network_id     = yandex_vpc_network.network_public.id
  v4_cidr_blocks = ["192.168.20.0/24"]

  # Используем route table с shared_egress_gateway
  route_table_id = yandex_vpc_route_table.route_public_table.id
}

# Security group для приватной VM
resource "yandex_vpc_security_group" "private_sg" {
  name       = "private-sg"
  network_id = yandex_vpc_network.network_public.id

  # SSH из публичной подсети (bastion)
  ingress {
    protocol       = "TCP"
    description    = "Allow SSH from public subnet"
    v4_cidr_blocks = [yandex_vpc_subnet.sub_network_public.v4_cidr_blocks[0]]
    port           = 22
  }

  # Разрешаем весь исходящий трафик (через Shared Egress Gateway)
  egress {
    protocol       = "ANY"
    description    = "Allow all outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Приватная VM
resource "yandex_compute_instance" "vm_private" {
  name        = "private-vm"
  platform_id = "standard-v3"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.os.image_id
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.sub_network_private.id
    nat                = false  # внутренний IP, без публичного
    security_group_ids = [yandex_vpc_security_group.private_sg.id]
  }

  metadata = {
    serial-port-enable = true
    ssh-keys           = "${var.ssh_user}:${file(var.ssh_key_path)}"
  }
}