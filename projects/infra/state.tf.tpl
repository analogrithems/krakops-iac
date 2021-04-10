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
