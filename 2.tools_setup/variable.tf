variable "region" {
  description = "Please provide a region"
  type        = string
  default     = ""
}
# This block is used to setup cert-manager
variable "cert-manager-config" {
  type        = map(any)
  description = "Please define cert-manager configurations"
  default = {
    deployment_name = "cert-manager"
    chart_version   = "1.10.0"
  }
}

variable "external-dns-config" {
  type        = map(any)
  description = "Please define external-dns configurations"
  default = {
    deployment_name = "external-dns"
    chart_version   = "6.18.0"
  }
}
variable "email" {
  description = "Please provide an email"
  type        = string
  default     = ""
}


# This block is used to setup prometheus
variable "prometheus-config" {
  type        = map(any)
  description = "Please define prometheus configurations"
  default = {
    deployment_name = "prometheus"
    chart_version   = "15.17.0"
  }
}

variable "domain_name" {
  description = "Please provide a domain"
  type        = string
  default     = ""
}

# This block is used to setup grafana
variable "grafana-config" {
  type = map(any)
  default = {
    deployment_name = "grafana"
    chart_version   = "6.43.3"
    adminPassword   = "password"
    adminUser       = "admin"
  }
}

# This block is used to setup kube-state-metrics
variable "kube-state-metrics-config" {
  type = map(any)
  default = {
    deployment_name = "kube-state-metrics"
    chart_version   = "4.22.1"
  }
}

variable "vault-config" {
  type        = map(any)
  description = "Please define prometheus configurations"
  default = {
    deployment_name = "vault"
    chart_version   = "0.22.1"
  }
}

variable "datadog-config" {
  type        = map(any)
  description = "Please provide datadog config"
  default = {
    deployment_name = "datadog"
    apiKey          = "486adc28b54026bb6a42480386407778"
    site            = "us5.datadoghq.com"
    cpu_requests    = "200m"
    memory_requests = "256Mi"
    cpu_limits      = "500m"
    memory_limits   = "1024Mi"
  }
}

variable "repository_id" {
  type    = string
  default = ""
}

variable "format" {
  type    = string
  default = "DOCKER"
}

variable "description" {
  type    = string
  default = ""
}

# This block is used to setup ingress controller
variable "ingress-controller-config" {
  type        = map(any)
  description = "Please define prometheus configurations"
  default = {
    deployment_name          = "ingress-controller"
    chart_version            = "4.3.0"
    loadBalancerSourceRanges = "0.0.0.0/0"
  }
}

# This block is used to setup ingress controller
variable "sftpgo-config" {
  type        = map(any)
  description = "Please define prometheus configurations"
  default = {
    deployment_name = "sftpgo"
    chart_version   = "0.12.0"

  }
}

# This block is used to setup ingress controller
variable "argo-config" {
  type        = map(any)
  description = "Please define prometheus configurations"
  default = {
    deployment_name = "argo"
    chart_version   = "5.20.5"

  }
}

# This block is used to setup github action runner
variable "ghrunner-config" {
  type        = map(any)
  description = "Please define prometheus configurations"
  default = {
    deployment_name            = "ghrunner"
    chart_version              = "0.22.0"
    github_app_id              = "236776"
    github_app_installation_id = "29078416"
  }
}
variable "bucket_name" {
  type        = string
  default     = ""
  description = "description"
}
