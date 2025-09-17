resource "exoscale_sks_nodepool" "standard-small-workers" {
  zone               = var.zone
  cluster_id         = exoscale_sks_cluster.sks.id
  name               = "workers-standard-${var.name}"
  instance_type      = "standard.small"
  size               = var.workers_number
  security_group_ids = [exoscale_security_group.sg_sks_nodes.id]
    labels           = {node-type = "standard"}

}

resource "exoscale_sks_nodepool" "gpu-small-workers" {
  zone               = var.zone
  cluster_id         = exoscale_sks_cluster.sks.id
  name               = "workers-gpu-${var.name}"
  instance_type      = "standard.medium" // for the demo, don't want to run GPU in prod
  size               = var.workers_number
  security_group_ids = [exoscale_security_group.sg_sks_nodes.id]
  labels             = {node-type = "gpu"}
}
