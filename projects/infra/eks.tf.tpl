module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = "1.19"
  create_fargate_pod_execution_role = true
  subnets         = module.vpc.private_subnets

  tags = {
    Environment = var.vpc_name
  }

  vpc_id = module.vpc.vpc_id


}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}