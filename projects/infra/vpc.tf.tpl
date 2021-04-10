# This uses Anton Babenko vpc module https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest to create a good VPC starting point
resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.66.0"

  name                 = var.vpc_name
  cidr                 = var.vpc_network
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = [cidrsubnet(var.vpc_network, 8, 90), cidrsubnet(var.vpc_network, 8, 91), cidrsubnet(var.vpc_network, 8, 92),]
  public_subnets       = [cidrsubnet(var.vpc_network, 8, 10), cidrsubnet(var.vpc_network, 8, 11), cidrsubnet(var.vpc_network, 8, 12)]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_efs_endpoint  = true
  enable_ecr_api_endpoint = true
  enable_ecr_dkr_endpoint = true
  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}