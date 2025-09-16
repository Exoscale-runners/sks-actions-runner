resource "helm_release" "gha_runner_controller" {
  namespace        = "gh-actions-runner"
  create_namespace = true
  recreate_pods    = true
  reuse_values     = false
  name             = "exo-arc"
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

resource "helm_release" "gha_runner_scale_set" {
  depends_on = [
    helm_release.gha_runner_controller
  ]
  namespace        = "gh-actions-runner"
  create_namespace = true
  recreate_pods    = true
  reuse_values     = false
  name             = var.gh_arc_installation_name
  repository       = "oci://ghcr.io/actions/actions-runner-controller-charts"
  chart            = "gha-runner-scale-set"
  version          = "0.12.1"
  set {
    name  = "githubConfigUrl"
    value = var.gha_org
  }
  set_sensitive {
    name  = "githubConfigSecret.github_token"
    value = var.gha_token
  }
  set {
    name  = "containerMode.type"
    value = "dind"
  }

  values = [
    <<-EOT
    podAnnotations:
      k8s.grafana.com/scrape: "true"
    EOT
  ]
}
