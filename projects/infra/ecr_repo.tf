resource "aws_ecr_repository" "this" {
  name                 = "litecoin-node"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}