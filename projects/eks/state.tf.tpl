terraform {
  backend "s3" {
    bucket  = "{{config['state']['bucket']}}"
    key     = "{{project}}/{{config['state']['region']}}/{{quadrant}}"
    region  = "{{config['state']['region']}}"
    encrypt = true
  }
}
provider "aws" {
  region = "{{config['state']['region']}}"
}

provider "random" {}

provider "local" {}

provider "null" {}

provider "template" {}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}