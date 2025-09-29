variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "network_name" {
  type = string
  default = "my-vpc"
}

variable "subnets" {
  type = list(object({
    name   = string
    zone   = string
    cidr   = string
  }))
  default = [
    { name = "subnet-a", zone = "ru-central1-a", cidr = "10.0.1.0/24" },
    { name = "subnet-b", zone = "ru-central1-b", cidr = "10.0.2.0/24" },
  ]
}
