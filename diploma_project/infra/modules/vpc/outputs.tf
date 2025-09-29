output "vpc_id" {
  value = yandex_vpc_network.vpc.id
}

output "subnet_ids" {
  value = { for k, s in yandex_vpc_subnet.subnets : k => s.id }
}