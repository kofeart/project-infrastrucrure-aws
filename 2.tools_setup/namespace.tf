module "tools" {
  source = "../modules/terraform-k8s-namespace"
  annotations = {
    name = "new-annotation"
  }
  labels = {
    name = "new-labels"
  }
  name = "tools"
}

module "dev" {
  source = "../modules/terraform-k8s-namespace"
  annotations = {
    name = "new-annotation"
  }
  labels = {
    name = "new-labels"
  }
  name = "dev"
}


module "canada" {
  source = "../modules/terraform-k8s-namespace"
  annotations = {
    name = "new-annotation"
  }
  labels = {
    name = "new-labels"
  }
  name = "canada"
}

module "qa" {
  source = "../modules/terraform-k8s-namespace"
  annotations = {
    name = "new-annotation"
  }
  labels = {
    name = "new-labels"
  }
  name = "qa"
}

module "stage" {
  source = "../modules/terraform-k8s-namespace"
  annotations = {
    name = "new-annotation"
  }
  labels = {
    name = "new-labels"
  }
  name = "stage"
}

module "prod" {
  source = "../modules/terraform-k8s-namespace"
  annotations = {
    name = "new-annotation"
  }
  labels = {
    name = "new-labels"
  }
  name = "prod"
}



module "canada-dev" {
  source = "../modules/terraform-k8s-namespace"
  annotations = {
    name = "new-annotation"
  }
  labels = {
    name = "new-labels"
  }
  name = "canada-dev"
}

module "canada-qa" {
  source = "../modules/terraform-k8s-namespace"
  annotations = {
    name = "new-annotation"
  }
  labels = {
    name = "new-labels"
  }
  name = "canada-qa"
}

module "canada-stage" {
  source = "../modules/terraform-k8s-namespace"
  annotations = {
    name = "new-annotation"
  }
  labels = {
    name = "new-labels"
  }
  name = "canada-stage"
}

module "canada-prod" {
  source = "../modules/terraform-k8s-namespace"
  annotations = {
    name = "new-annotation"
  }
  labels = {
    name = "new-labels"
  }
  name = "canada-prod"
}


module "au-prod" {
  source = "../modules/terraform-k8s-namespace"
  annotations = {
    name = "new-annotation"
  }
  labels = {
    name = "new-labels"
  }
  name = "au-prod"
}