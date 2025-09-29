output "vpc_id" {
  value = yandex_vpc_network.vpc.id
}

output "subnet_ids" {
  value = { for k, s in yandex_vpc_subnet.subnets : k => s.id }
}

output "subnet_a_id" {
  value = yandex_vpc_subnet.subnets["subnet-a"].id
}

output "subnet_b_id" {
  value = yandex_vpc_subnet.subnets["subnet-b"].id
}

output "subnet_d_id" {
  value = yandex_vpc_subnet.subnets["subnet-d"].id
}
