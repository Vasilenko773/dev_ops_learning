variable "bucket_name" {
  type        = string
  default     = "green773-20250905"
  description = "Имя бакета Object Storage"
}

variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "network_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "network_name" {
  type        = string
  default     = "network_yandex_cloud"
  description = ""
}

variable "network_cidr" {
  type        = list(string)
  default     = ["10.10.0.0/16"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "public_network_cidr" {
  type        = list(string)
  default     = ["10.10.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}


variable "vm_os" {
  type        = string
  default     = "ubuntu-2404-lts"
  description = "Уникальный идентификатор семейста ОС для образа ВМ"
}

variable "ssh_key_path" {
  type        = string
  default = "~/.ssh/id_ed25519.pub"
  description = "Обязательно нужно указывать для подключения суперпользователя напрмиер ubuntu - так как они существуют в OS"
}

variable "ssh_user" {
  type        = string
  default     = "green773"
  description = "имя учетной записи"
}