locals {
  account_id  = data.aws_caller_identity.current.account_id
  name_prefix = "${var.vpc_name}-"

  role_name   = "${local.name_prefix}${var.random_suffix == "true" ? random_string.suffix.result : "role"}"
  policy_name = "${local.name_prefix}${var.random_suffix == "true" ? random_string.suffix.result : "policy"}"
  group_name  = "${local.name_prefix}${var.random_suffix == "true" ? random_string.suffix.result : "group"}"
  user_name   = "${local.name_prefix}${var.random_suffix == "true" ? random_string.suffix.result : "user"}"
}


resource "random_string" "suffix" {
  length  = 8
  special = false
}