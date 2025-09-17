terraform {
  required_providers {
    exoscale = {
      source  = "exoscale/exoscale"
      version = "~> 0.65.1"
    }
  }
}

provider "exoscale" {
  key    = var.exoscale_api_key
  secret = var.exoscale_secret_key
}

provider "helm" {
  kubernetes = {
    config_path = local_sensitive_file.sks_kubeconfig_file.filename
  }
}
