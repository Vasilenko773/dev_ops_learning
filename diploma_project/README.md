1. Необходимые предварительные действия для настройки окружения:
   - cd ./bootstrap
   - terraform init
   - terraform apply
   - Настроить права для backend s3 (указать секреты в ~/.terraform/credential.txt)
   - yc iam key create --service-account-id идентификатор сервисного акаунта --output ../sa-key.json