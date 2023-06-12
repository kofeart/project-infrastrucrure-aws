resource "aws_iam_policy" "alb_ingress_controller_policy" {
  name        = "alb_ingress_controller_policy"
  description = "Policy for ALB ingress controller"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:CreateSecurityGroup",
          "ec2:CreateTags",
          "ec2:DeleteTags",
          "ec2:Describe*",
          "elasticloadbalancing:AddListenerCertificates",
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:CreateRule",
          "elasticloadbalancing:CreateTargetGroup",
          "elasticloadbalancing:DeleteListener",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:DeleteRule",
          "elasticloadbalancing:DeleteTargetGroup",
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:Describe*",
          "elasticloadbalancing:ModifyListener",
          "elasticloadbalancing:ModifyLoadBalancerAttributes",
          "elasticloadbalancing:ModifyRule",
          "elasticloadbalancing:ModifyTargetGroup",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:RemoveListenerCertificates",
          "elasticloadbalancing:RemoveTags",
          "elasticloadbalancing:SetIpAddressType",
          "elasticloadbalancing:SetSecurityGroups",
          "elasticloadbalancing:SetSubnets",
          "elasticloadbalancing:SetWebAcl"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = "sts:AssumeRoleWithWebIdentity"
        Resource = "*"
        Condition = {
          StringEquals = {
            "cognito-identity.amazonaws.com:aud" = "sts.amazonaws.com"
          }
          "ForAnyValue:StringLike" = {
            "cognito-identity.amazonaws.com:amr" = "authenticated"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role" "alb_ingress_controller_role" {
  name = "alb_ingress_controller_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${data.terraform_remote_state.remote.outputs.oidc_provider}"
        }
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "${data.terraform_remote_state.remote.outputs.cluster_oidc_issuer_url}:sub" : "system:serviceaccount:ingress-controller:ingress-controller"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "alb_ingress_controller_attachment" {
  policy_arn = aws_iam_policy.alb_ingress_controller_policy.arn
  role       = aws_iam_role.alb_ingress_controller_role.name
}



module "ingress-terraform-k8s-namespace" {
  source = "../modules/terraform-k8s-namespace/"
  name   = "ingress"
}

module "ingress-terraform-helm" {
  source               = "../modules/terraform-helm/"
  deployment_name      = "ingress"
  deployment_namespace = module.ingress-terraform-k8s-namespace.namespace
  chart                = "ingress-nginx"
  chart_version        = var.ingress-controller-config["chart_version"]
  repository           = "https://kubernetes.github.io/ingress-nginx"
  values_yaml          = <<EOF
  type: "Ingress"
  ingress:
    metricsPort: "8080"
  deployment:
    replicas: 2
    service:
      type: ClusterIP
      port: "8080"
    controller:
      service:
        type: LoadBalancer
        loadBalancerSourceRanges: [
          "${var.ingress-controller-config["loadBalancerSourceRanges"]}",
        ]
        serviceAccount:
          create: true
        annotations:
          service.beta.kubernetes.io/aws-load-balancer-type: nlb
          service.beta.kubernetes.io/aws-load-balancer-backend-protocol: http
          service.beta.kubernetes.io/aws-load-balancer-ssl-ports: https
          service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: "true"
          service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout: "60"
          kubernetes.io/ingress.class: alb
          alb.ingress.kubernetes.io/scheme: internet-facing
          alb.ingress.kubernetes.io/tags: Environmen:testing
          alb.ingress.kubernetes.io/listen-ports: [{\HTTP\: 80}, {\HTTPS\: 443}]
          nginx.ingress.kubernetes.io/rewrite-target: "/"
      path: /
      hosts:
        - "ingress.kudratillo.org"
      tls:
        - secretName: ingress
          hosts:
            - "ingress.kudratillo.org"
EOF
}
