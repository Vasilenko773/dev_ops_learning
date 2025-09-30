
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
  # Подсети и зоны для отдельных node groups
  subnet_a_id = module.vpc.subnet_a_id
  subnet_b_id = module.vpc.subnet_b_id
  subnet_d_id = module.vpc.subnet_d_id
  subnet_ids = [module.vpc.subnet_a_id, module.vpc.subnet_b_id, module.vpc.subnet_d_id]
  zones             = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]
  k8s_version       = "1.30"
  node_platform_id  = "standard-v3"
  node_memory       = 4
  node_cores        = 2
  node_min_hosts    = 1
  node_max_hosts    = 3

  service_account_id      = var.terraform_sa_id
  node_service_account_id = var.terraform_sa_id
}


module "docker_registry" {
  source     = "./modules/docker"
  service_account_id = var.terraform_sa_id
  folder_id  = var.folder_id
}

output "my_registry_endpoint" {
  value = module.docker_registry.my_registry_endpoint
}

output "registry_sa_private_key" {
  value     = module.docker_registry.registry_sa_private_key
  sensitive = true
}