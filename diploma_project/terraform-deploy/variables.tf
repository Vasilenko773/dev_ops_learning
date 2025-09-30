###cloud vars
variable "path_to_config" {
  type        = string
  description = "Путь до конфиг файла k8s"
}

variable "image_repository" {
  type = string
  description = "Registry в Яндекс облаке"
}

variable "image_tag" {
  type = string
  description = "tag образа в Яндекс облаке"
}
