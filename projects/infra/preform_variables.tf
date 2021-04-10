##################################################
# This file auto generated by preform, do not edit!
# Instead edit 
# /Users/aaroncollins/Development/kraken/iac/projects/infra/variables.tf.tpl
##################################################


# Global Configs
variable "master_public_key" {
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFrhLPR9lJF8sKLhzNg5THyrBuwxxxDMMJoEbzYEWm+u aaron.collinsa+kraken@gmail.com"
}
variable "primary_domain" {
  default = "krakops-dev.com"
}
variable "vpc_name" {
  default = "dev"
}
variable "vpc_network" {
  default = "10.30.0.0/16"
}

# State Configs

variable "bucket" {
  default = "krakops-iac"
}


variable "encrypt" {
  default = "True"
}


variable "region" {
  default = "us-west-1"
}


variable "services" {
  type = map(string)

  default = {}
}

