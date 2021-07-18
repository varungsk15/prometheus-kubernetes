provider "helm" {
  kubernetes {
    host     = module.application_cluster.cluster_endpoint
    token    = data.google_client_config.this.access_token
    insecure = true
  }
}

resource "helm_release" "kube-prometheus-stack" {
  name       = "kube-prometheus-stack"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  set {
    name  = "grafana.enabled"
    value = "false"
  }
}
