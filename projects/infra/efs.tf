resource "aws_efs_file_system" "efs_data" {
  creation_token   = "${local.cluster_name}-eks"
  encrypted        = true
  performance_mode = "generalPurpose" #maxIO
  throughput_mode  = "bursting"
  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.cluster_name}-EKS-Shared"
    },
  )
}

resource "aws_efs_access_point" "efs_data" {
  file_system_id = aws_efs_file_system.efs_data.id
}

resource "aws_efs_mount_target" "EKS_mount" {
  count           = length(module.vpc.private_subnets)
  file_system_id  = aws_efs_file_system.efs_data.id
  security_groups = [aws_security_group.private_efs.id]
  subnet_id       = module.vpc.private_subnets[count.index]
}

resource "aws_security_group" "private_efs" {
  name = "${local.cluster_name}-private-efs"

  tags = merge(
    local.common_tags,
    map(
      "Name", "${local.cluster_name}-private-efs"
    )
  )

  vpc_id = module.vpc.vpc_id
}


resource "aws_security_group_rule" "private_EKS_ingress_efs" {
  description              = "EFS ingress from EKS subnet"
  from_port                = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private_efs.id
  source_security_group_id = aws_security_group.private_eks.id
  to_port                  = 2049
  type                     = "ingress"
}

# module.vpc.private_subnets