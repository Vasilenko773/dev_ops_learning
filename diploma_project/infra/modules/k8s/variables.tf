variable "folder_id" {
  description = "ID папки Yandex Cloud"
  type        = string
}

variable "network_id" {
  description = "ID VPC сети"
  type        = string
}

variable "subnet_ids" {
  description = "Список ID подсетей для node group"
  type        = list(string)
}

variable "k8s_version" {
  description = "Версия Kubernetes"
  type        = string
  default     = "1.30"
}

variable "node_platform_id" {
  description = "Тип виртуальной машины для нод"
  type        = string
  default     = "standard-v1"
}

variable "node_memory" {
  description = "Память на ноду (GB)"
  type        = number
  default     = 4
}

variable "node_cores" {
  description = "CPU cores на ноду"
  type        = number
  default     = 2
}

variable "node_min_hosts" {
  description = "Минимальное число хостов"
  type        = number
  default     = 1
}

variable "node_max_hosts" {
  description = "Максимальное число хостов"
  type        = number
  default     = 3
}

variable "zones" {
  description = "Зоны размещения нод"
  type        = list(string)
  default     = ["ru-central1-a", "ru-central1-b"]
}

variable "service_account_id" {
  type        = string
  description = "ID сервисного аккаунта для Kubernetes"
}

variable "node_service_account_id" {
  type        = string
  description = "ID сервисного аккаунта для нод"
}