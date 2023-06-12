module "prometheus-terraform-k8s-namespace" {
  source = "../modules/terraform-k8s-namespace/"
  name   = "prometheus"
}

module "prometheus-terraform-helm" {
  source               = "../modules/terraform-helm/"
  deployment_name      = "prometheus"
  deployment_namespace = module.prometheus-terraform-k8s-namespace.namespace
  chart                = "prometheus"
  repository           = "https://prometheus-community.github.io/helm-charts"
  chart_version        = var.prometheus-config["chart_version"]
  values_yaml          = <<-EOF
alertmanager:
  ingress:
    enabled: true
    annotations: 
      ingress.kubernetes.io/ssl-redirect: "false"
      kubernetes.io/ingress.class: nginx
      cert-manager.io/cluster-issuer: letsencrypt-prod
      acme.cert-manager.io/http01-edit-in-place: "true"
    hosts: 
      - "alertmanager.${var.domain_name}"
    tls: 
      - secretName: alertmanager
        hosts:
          - "alertmanager.${var.domain_name}"

server:
  deploymentAnnotations: {
    "cluster-autoscaler.kubernetes.io/safe-to-evict": "true"
  }
  enabled: true
  ingress:
    enabled: true
    annotations:
      ingress.kubernetes.io/ssl-redirect: "false"
      kubernetes.io/ingress.class: nginx
      cert-manager.io/cluster-issuer: letsencrypt-prod
      acme.cert-manager.io/http01-edit-in-place: "true"
    hosts: 
      - "prometheus.${var.domain_name}"
    tls: 
      - secretName: prometheus-server-tls
        hosts:
          - "prometheus.${var.domain_name}"
  EOF
}
