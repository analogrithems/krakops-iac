locals {
  account_id   = data.aws_caller_identity.current.account_id
  app          = "litecoin-node"
  cluster_name = "${var.vpc_name}-${local.random}"
  common_tags = {
    Environment = var.vpc_name
    GithubRepo  = "krakops-iac"
    GithubOrg   = "analogrithems"
    terraform   = "true"
    vpc         = var.vpc_name
  }

  namespace          = "crypto-node"
  random             = random_string.suffix.result
  storage_class_name = "crypto-node"
}