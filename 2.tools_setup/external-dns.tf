# gets entire account info
data "aws_caller_identity" "current" {}

# prints out account id
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

resource "aws_iam_policy" "external-dns" {
  name        = "external-dns"
  description = "My external-dns"
  policy = jsonencode(
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
)
}


resource "aws_iam_role" "external-dns-role" {
  name = "external-dns-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${data.terraform_remote_state.remote.outputs.oidc_provider}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${data.terraform_remote_state.remote.outputs.cluster_oidc_issuer_url}:sub": "system:serviceaccount:external-dns:external-dns"
        }
      }
    }
  ]
}
EOF
}



resource "aws_iam_policy_attachment" "external-dns" {
  name       = "external-dns-attachment"
  roles      = [aws_iam_role.external-dns-role.name]
  policy_arn = aws_iam_policy.external-dns.arn
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

serviceAccount:
  create: true
  name: "external-dns"
  annotations: 
    eks.amazonaws.com/role-arn: "${aws_iam_role.external-dns-role.arn}"
EOF
}
