
resource "aws_iam_policy" "cert-manager" {
  name        = "cert-manager"
  description = "My cert-manager"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "route53:ChangeResourceRecordSets"
          ],
          "Resource" : [
            "arn:aws:route53:::hostedzone/*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "route53:ListHostedZones",
            "route53:ListResourceRecordSets"
          ],
          "Resource" : [
            "*"
          ]
        }
      ]
    }
  )
}


resource "aws_iam_role" "cert-manager-role" {
  name               = "cert-manager-role"
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
          "${data.terraform_remote_state.remote.outputs.oidc_provider}:sub": "system:serviceaccount:cert-manager:cert-manager"
        }
      }
    }
  ]
}
EOF
}


resource "aws_iam_policy_attachment" "cert-manager" {
  name       = "cert-manager-attachment"
  roles      = [aws_iam_role.cert-manager-role.name]
  policy_arn = aws_iam_policy.cert-manager.arn
}





module "cert-manager-terraform-k8s-namespace" {
  source = "../modules/terraform-k8s-namespace/"
  name   = "cert-manager"
}

module "cert-mananger-terraform-helm" {
  source               = "../modules/terraform-helm/"
  deployment_name      = "cert-manager"
  deployment_namespace = module.cert-manager-terraform-k8s-namespace.namespace
  chart                = "cert-manager"
  chart_version        = var.cert-manager-config["chart_version"]
  repository           = "https://charts.jetstack.io"
  values_yaml          = <<EOF
podDnsPolicy: "None"
podDnsConfig:
  nameservers:
    - "8.8.4.4"
    - "8.8.8.8"
installCRDs: true

serviceAccount:
  create: true
  name: "cert-manager"
  annotations: 
    eks.amazonaws.com/role-arn: "${aws_iam_role.cert-manager-role.arn}"
EOF
}

module "lets-encrypt" {
  depends_on = [
    module.cert-mananger-terraform-helm
  ]
  source               = "../modules/terraform-helm-local/"
  deployment_name      = "lets-encrypt"
  deployment_namespace = "cert-manager"
  deployment_path      = "charts/lets-encrypt"
  values_yaml          = <<EOF
email: "${var.email}"
domain_name: "${var.domain_name}"
EOF
}
