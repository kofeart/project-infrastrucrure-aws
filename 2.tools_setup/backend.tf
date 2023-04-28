terraform {
  backend "s3" {
    bucket = "terraform-project-for-class"
    key    = "dev/mnt/farrukh90/project_infrastructure_aws/2.tools_setup"
    region = "us-east-1"
  }
}
