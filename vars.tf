
# For VPC Module
variable "vpc" {}
variable "region" {}

# For ec2-instance module
# variable "subnet_id" {} 
variable "ec2-instance" {} 
# variable "ec2-sg" {}
variable "ami_id" {}
variable "ec2-bastion" {}

variable "root_volume_size" {}
variable "root_volume_type" {}