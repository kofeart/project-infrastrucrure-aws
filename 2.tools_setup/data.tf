data "terraform_remote_state" "remote" {
  backend = "s3"
  config = {
    bucket = var.bucket_name
    key    = "dev${local.path}/1.cluster_setup"
    region = var.region
  }
}


locals {
  path = abspath("${path.cwd}/..")
}
