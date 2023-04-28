# gets entire account info
data "aws_caller_identity" "current" {}

# prints out account id
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

# locals {
#   oidc_url = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
# }

# resource "aws_iam_role" "external-dns-role" {
#   name = "external-dns-role"
#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_url}"
#       },
#       "Action": "sts:AssumeRoleWithWebIdentity",
#       "Condition": {
#         "StringEquals": {
#           "${local.oidc_url}:sub": "system:serviceaccount:external-dns:external-dns"
#         }
#       }
#     }
#   ]
# }
# EOF
# }

module "external-dns-terraform-k8s-namespace" {
  source = "../modules/terraform-k8s-namespace/"
  name   = "external-dns"
}

module "external-dns-terraform-helm" {
  source               = "../modules/terraform-helm/"
  deployment_name      = "external-dns"
  deployment_namespace = module.external-dns-terraform-k8s-namespace.namespace
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
