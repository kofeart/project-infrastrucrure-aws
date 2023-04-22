

module "external-dns-terraform-helm" {
  source               = "../modules/terraform-helm/"
  deployment_name      = "external-dns"
  chart                = "external-dns"
  chart_version        = var.external-dns-config["chart_version"]
  repository           = "https://charts.bitnami.com/bitnami"
  values_yaml          = <<EOF
commonAnnotations: {
  "cluster-autoscaler.kubernetes.io/safe-to-evict": "true"
}
provider: aws
rbac:
  create: true

# Below policy is need to keep DNS records clean
EOF
}