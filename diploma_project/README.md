1. Необходимые предварительные действия для настройки окружения:
   - cd ./bootstrap
   - terraform init
   - terraform apply
   - Настроить права для backend s3 (указать секреты в ~/.terraform/credential.txt)
   - yc iam key create --service-account-id идентификатор сервисного акаунта --output ../sa-key.json

2. Конфигурация config для кластрера k8s:
   - yc managed-kubernetes cluster get-credentials my-k8s-cluster --external --force
   
3. Создание ingress контроллера:
   - helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
   - helm repo update
   - kubectl create namespace ingress-nginx
   - helm install ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx --set controller.replicaCount=2 --set controller.nodeSelector."kubernetes\.io/os"=linux --set defaultBackend.nodeSelector."kubernetes\.io/os"=linux

4. Настройка мониторинга:
   - cd /monitoring
   - terraform apply
