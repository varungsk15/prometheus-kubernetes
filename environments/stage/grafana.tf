resource "helm_release" "grafana" {
  name       = "grafana"

  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"

  set {
      name  = "datasources.datasources\\.yaml.apiVersion"
      value = "1"
    }
  set {
      name  = "datasources.datasources\\.yaml.datasources[0].name"
      value = "Prometheus"
    }
  set {
      name  = "datasources.datasources\\.yaml.datasources[0].type"
      value = "prometheus"
    }
  set {
      name  = "datasources.datasources\\.yaml.datasources[0].url"
      value = "http://kube-prometheus-stack-prometheus\\.default:9090"
    }
  set {
      name  = "datasources.datasources\\.yaml.datasources[0].access"
      value = "proxy"
    }
  set {
      name  = "datasources.datasources\\.yaml.datasources[0].isDefault"
      value = "true"
    }

}
