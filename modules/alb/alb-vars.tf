variable "public_subnet" {}
variable "private_subnet" {}
variable "alb-ext-sg" {}

variable "vpc_id"{}
#variable "ec2-instance-id" {}
variable "ec2-web-1" {}
variable "ec2-web-2" {}


variable "az" {
    type = list(string)
}