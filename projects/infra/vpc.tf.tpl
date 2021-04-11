# This uses Anton Babenko vpc module https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest to create a good VPC starting point
resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.78.0"

  name                 = var.vpc_name
  cidr                 = var.vpc_network
  azs                  = ["us-west-1a", "us-west-1b"]
  private_subnets      = [cidrsubnet(var.vpc_network, 8, 90), cidrsubnet(var.vpc_network, 8, 91)]
  public_subnets       = [cidrsubnet(var.vpc_network, 8, 10), cidrsubnet(var.vpc_network, 8, 11)]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  
/**
  enable_efs_endpoint  = true
  efs_endpoint_private_dns_enabled = true
  efs_endpoint_security_group_ids  = [data.aws_security_group.default.id]
    
  enable_s3_endpoint              = true
  s3_endpoint_type                = "Interface"
  s3_endpoint_private_dns_enabled = false
  s3_endpoint_security_group_ids  = [data.aws_security_group.default.id]
  
  # VPC endpoint for SSM
  enable_ssm_endpoint              = true
  ssm_endpoint_private_dns_enabled = true
  ssm_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC endpoint for Lambda
  enable_lambda_endpoint              = true
  lambda_endpoint_private_dns_enabled = true
  lambda_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC endpoint for SSMMESSAGES
  enable_ssmmessages_endpoint              = true
  ssmmessages_endpoint_private_dns_enabled = true
  ssmmessages_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC Endpoint for ECR API
  enable_ecr_api_endpoint              = true
 # ecr_api_endpoint_policy              = data.aws_iam_policy_document.generic_endpoint_policy.json
  ecr_api_endpoint_private_dns_enabled = true
  ecr_api_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC Endpoint for ECR DKR
  enable_ecr_dkr_endpoint              = true
  #ecr_dkr_endpoint_policy              = data.aws_iam_policy_document.generic_endpoint_policy.json
  ecr_dkr_endpoint_private_dns_enabled = true
  ecr_dkr_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC endpoint for KMS
  enable_kms_endpoint              = true
  kms_endpoint_private_dns_enabled = true
  kms_endpoint_security_group_ids  = [data.aws_security_group.default.id]
  
  # Default security group - ingress/egress rules cleared to deny all
  manage_default_security_group  = true
  default_security_group_ingress = []
  default_security_group_egress  = []

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60
 */
  
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