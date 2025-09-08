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
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "Allow HTTP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  # outbound any
  egress {
    protocol       = "ANY"
    description    = "Allow all outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
