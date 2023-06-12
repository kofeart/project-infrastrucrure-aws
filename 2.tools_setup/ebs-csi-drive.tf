resource "aws_iam_policy" "ebs-csi-controller-sa" {
  name        = "ebs-csi-controller-sa"
  description = "My ebs-csi-controller-sa"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "ec2:*"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}

resource "aws_iam_role" "ebs-csi-controller-sa-role" {
  name               = "ebs-csi-controller-sa-role"
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
          "${data.terraform_remote_state.remote.outputs.oidc_provider}:sub": "system:serviceaccount:kube-system:ebs-csi-controller-sa"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "ebs-csi-controller-sa" {
  name       = "ebs-csi-controller-sa-attachment"
  roles      = [aws_iam_role.ebs-csi-controller-sa-role.name]
  policy_arn = aws_iam_policy.ebs-csi-controller-sa.arn
}

module "ebs-csi-terraform-helm" {
  source               = "../modules/terraform-helm/"
  deployment_name      = "aws-ebs-csi-driver"
  deployment_namespace = "kube-system"
  chart                = "aws-ebs-csi-driver"
  chart_version        = "2.17.1"
  repository           = "https://charts.deliveryhero.io/"
  values_yaml          = <<EOF
controller:
  serviceAccount:
    create: true
    name: ebs-csi-controller-sa
    annotations:
      eks.amazonaws.com/role-arn: "${aws_iam_role.ebs-csi-controller-sa-role.arn}"
EOF
}
