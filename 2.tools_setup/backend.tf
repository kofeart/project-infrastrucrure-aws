terraform {
  backend "s3" {
    bucket = "terraform-state-backend-kudratillo"
    key = "dev/home/ec2-user/project_infrastructure_aws/2.tools_setup"
    region = "us-east-1"
  }
}
