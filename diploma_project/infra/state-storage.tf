resource "yandex_storage_bucket" "tf-state" {
  bucket    = "tf-state-bucket-for-state-storage"
  folder_id = var.folder_id
  versioning {
    enabled = true
  }
  anonymous_access_flags {
    read = false
    list = false
  }
  force_destroy = true
}