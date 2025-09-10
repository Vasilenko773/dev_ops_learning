resource "yandex_kms_symmetric_key" "kms_key" {
  name              = "bucket-encryption-key"
  description       = "KMS key for Object Storage encryption"
  default_algorithm = "AES_256"
  rotation_period   = "8760h"
  folder_id         = var.folder_id
}


resource "yandex_kms_symmetric_key_iam_binding" "binding" {
  symmetric_key_id = yandex_kms_symmetric_key.kms_key.id
  role             = "kms.keys.encrypterDecrypter"
  members = [
    "serviceAccount:${yandex_iam_service_account.vm_sa.id}"
  ]
}