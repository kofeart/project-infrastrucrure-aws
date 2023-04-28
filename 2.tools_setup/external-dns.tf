resource "aws_iam_role" "external-dns-role" {
  name = "external-dns-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "AllowAssumeExternalDNSRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

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
