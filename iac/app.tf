data "kubectl_path_documents" "arctavia" {
  pattern = "./arctavia/*.yaml"
  vars    = { docker_image = "danielpickens/customapp:1.0" }
}

resource "kubectl_manifest" "arctavia" {
  for_each  = toset(sort(data.kubectl_path_documents.arctavia.documents))
  yaml_body = each.value

  depends_on = [
    helm_release.kubernetes_dashboard,
    helm_release.ingress-nginx,
    helm_release.prometheus,
    helm_release.grafana,
    helm_release.elasticsearch,
    helm_release.kibana,
    helm_release.dapr
  ]
}