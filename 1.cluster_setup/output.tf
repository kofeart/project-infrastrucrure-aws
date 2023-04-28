output "next_step" {
  value       = <<EOF



                Great job, you were able to deploy Amazon EKS Cluster. Please follow below instructions
                1. https://aws.amazon.com/
                2. Search for Amazon Kubernetes Service
                3. Make sure everything is working good
                



  EOF
  sensitive   = false
  description = "description"
  depends_on  = []
}

output cluster_oidc_issuer_url {
  value = module.eks.cluster_oidc_issuer_url
}

output oidc_provider {
  value = module.eks.oidc_provider
}

output oidc_provider_arn {
  value = module.eks.oidc_provider_arn
}
