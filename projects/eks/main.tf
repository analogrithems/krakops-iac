/**
 * # Kubernetes in AWS Fargate
 * This project makes use of two popular terraform modules
 *
 * * [vpc](https://github.com/terraform-aws-modules/terraform-aws-vpc)
 * * [eks](https://github.com/terraform-aws-modules/terraform-aws-eks)
 *
 * To create a statefulset we then create and efs storage resource and then define 
 * kubernetes volume claims
 *
 * ## kubeconfig
 * After this runs it creates a kubrconfig file in the directory you run it from
 * example: ./kubeconfig_dev-Jovb4uv0
 *
 * After you run this install you need to use awscli to configure kubectl
 *
 * ```
 * aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
 * ```
 *
 * You also need to install aws-iam-authenticator
 *
 * ```
 * https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html
 * ```
 *
 */

# https://github.com/terraform-aws-modules/terraform-aws-vpc
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  #  version = "2.47.0"

  name                 = var.vpc_name
  cidr                 = var.vpc_network
  azs                  = ["us-west-1b", "us-west-1c"]
  private_subnets      = [cidrsubnet(var.vpc_network, 8, 21), cidrsubnet(var.vpc_network, 8, 22)]
  public_subnets       = [cidrsubnet(var.vpc_network, 8, 31), cidrsubnet(var.vpc_network, 8, 32)]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}


# https://github.com/terraform-aws-modules/terraform-aws-eks
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = "1.18"
  cluster_enabled_log_types = ["api","audit","authenticator","controllerManager","scheduler"]
  subnets         = module.vpc.private_subnets

  tags = local.common_tags

  vpc_id = module.vpc.vpc_id

  fargate_profiles = {
    fargate = {
      namespace = local.namespace

      # Kubernetes labels for selection
      labels = {
        Environment = var.vpc_name
      }

      tags = local.common_tags
    }
  }

  map_roles    = var.map_roles
  map_users    = var.map_users
  map_accounts = var.map_accounts
}


resource "kubernetes_namespace" "crypto_node" {
  metadata {
    annotations = {
      name = local.namespace
    }

    labels = {
      mylabel = local.namespace
    }

    name = local.namespace
  }
}