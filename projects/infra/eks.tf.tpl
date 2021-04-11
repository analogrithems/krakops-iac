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

resource "aws_security_group" "private_eks" {
  name = "${local.cluster_name}-private-eks"

  tags = merge(
    local.common_tags,
    map(
      "Name", "${local.cluster_name}-private-eks"
    )
  )

  vpc_id = module.vpc.vpc_id
}


resource "aws_security_group_rule" "private_eks_ingress_vpn_client_ssh" {
  description       = "Allow all traffic into EKS Cluster"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = [var.vpc_network]
  security_group_id = aws_security_group.private_eks.id
  type              = "ingress"
}


resource "aws_security_group_rule" "private_eks_tcp_egress_all" {
  from_port         = 0
  protocol          = "tcp"
  to_port           = 65535
  type              = "egress"
  security_group_id = aws_security_group.private_eks.id
  description       = "All TCP egress"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "private_eks_udp_egress_all" {
  from_port         = 0
  protocol          = "udp"
  to_port           = 65535
  type              = "egress"
  security_group_id = aws_security_group.private_eks.id
  description       = "All UDP egress"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "private_eks_icmp_df_egress_all" {
  from_port         = 3
  protocol          = "icmp"
  to_port           = -1
  type              = "egress"
  security_group_id = aws_security_group.private_eks.id
  description       = "ICMP Path MTU Discovery egress"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "private_eks_icmp_ping_egress_all" {
  from_port         = 8
  protocol          = "icmp"
  to_port           = 0
  type              = "egress"
  security_group_id = aws_security_group.private_eks.id
  description       = "ICMP ping egress"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}