1. Необходимые предварительные действия для настройки окружения:
   - cd ./bootstrap
   - terraform init
   - terraform apply
   - Настроить права для backend s3 (указать секреты в ~/.terraform/credential.txt)
   - yc iam key create --service-account-id идентификатор сервисного акаунта --output ../sa-key.json

2. Конфигурация config для кластрера k8s:
   - yc managed-kubernetes cluster get-credentials my-k8s-cluster --external --force