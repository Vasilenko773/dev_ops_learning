provider "kubernetes" {
  config_path = var.path_to_config
}

provider "helm" {
  kubernetes = {
    config_path = var.path_to_config
  }
}


resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "45.0.0"
  namespace  = "monitoring"

  create_namespace = true
}

resource "helm_release" "java_app" {
  name       = "java-app"
  chart      = "${path.module}/../app/.helm"
  namespace  = "my-app"
  create_namespace = true

  set = [
    {
      name  = "image.repository"
      value = var.image_repository
    },
    {
      name  = "image.tag"
      value = var.image_tag
    }
  ]
}
