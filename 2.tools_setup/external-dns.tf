

module "external-dns-terraform-helm" {
  source               = "../modules/terraform-helm/"
  deployment_name      = "external-dns"
  chart                = "external-dns"
  chart_version        = var.external-dns-config["chart_version"]
  repository           = "https://charts.bitnami.com/bitnami"
  values_yaml          = <<EOF
commonAnnotations: {
  cluster-autoscaler.kubernetes.io/safe-to-evict: "true"
}
clusterDomain: "${var.domain_name}"

aws:
  region: "${var.region}"
  zoneType: public

rbac:
  create: true

EOF
}
