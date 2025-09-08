# Бакет Object Storage
resource "yandex_storage_bucket" "my_bucket" {
  bucket = var.bucket_name
  folder_id = var.folder_id

  # включаем публичный доступ
  anonymous_access_flags {
    read = true   # разрешаем скачивание файлов
    list = false  # запрет на листинг содержимого бакета
  }
}

# Файл (картинка) в бакете
resource "yandex_storage_object" "my_image" {
  bucket = yandex_storage_bucket.my_bucket.bucket
  key    = "devops.jpg"
  source = "C:/devOps/dev_ops_learning/cloud_network/02/resources/devops.jpg"
  acl    = "public-read"
  content_type = "image/jpeg"
}

output "image_url" {
  value = "https://${yandex_storage_bucket.my_bucket.bucket}.storage.yandexcloud.net/${yandex_storage_object.my_image.key}"
}
