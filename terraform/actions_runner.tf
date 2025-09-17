resource "helm_release" "controller" {
  namespace        = "exo-arc-system"
  create_namespace = true
  recreate_pods    = true
  reuse_values     = false
  name             = "exo-arc-controller"
  repository       = "oci://ghcr.io/actions/actions-runner-controller-charts"
  chart            = "gha-runner-scale-set-controller"
  version          = "0.12.1"

  values = [
    <<-EOT
    podAnnotations:
      k8s.grafana.com/scrape: "true"
    EOT
  ]
}

resource "helm_release" "runner" {
  depends_on = [
    helm_release.gha_runner_controller
  ]
  namespace        = "exo-arc-runners"
  create_namespace = true
  recreate_pods    = true
  reuse_values     = false
  name             = var.gh_arc_installation_name
  repository       = "oci://ghcr.io/actions/actions-runner-controller-charts"
  chart            = "gha-runner-scale-set"
  version          = "0.12.1"
  set = [
    {
    name  = "githubConfigUrl"
    value = var.gha_org
  },
  {
    name  = "containerMode.type"
    value = "dind"
  }]
  set_sensitive = [{
    name  = "githubConfigSecret.github_token"
    value = var.gha_token
  }]

  values = [
    <<-EOT
    podAnnotations:
      k8s.grafana.com/scrape: "true"
    EOT
  ]
}
