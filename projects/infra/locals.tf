locals {
  cluster_name = "${var.vpc_name}-krakops-${random_string.suffix.result}"

  common_tags = {
    project   = "infrastructure"
    terraform = "true"
    vpc_name  = var.vpc_name
  }
}
