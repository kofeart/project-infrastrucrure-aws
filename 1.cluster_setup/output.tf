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
