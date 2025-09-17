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

resource "helm_release" "gpu-runner" {
  depends_on = [
    helm_release.controller
  ]
  namespace        = "exo-arc-runner"
  create_namespace = true
  recreate_pods    = true
  reuse_values     = false
  name             = "exo-arc-gpu-runner"
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
    template:
      spec:
        nodeSelector:
          node-type: gpu
    EOT
  ]
}

resource "helm_release" "standard-runner" {
  depends_on = [
    helm_release.controller
  ]
  namespace        = "exo-arc-runner"
  create_namespace = true
  recreate_pods    = true
  reuse_values     = false
  name             = "exo-arc-standard-runner"
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
    template:
      spec:
        nodeSelector:
          node-type: standard
    EOT
  ]
}
