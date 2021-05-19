resource "aws_security_group" "alb-ext-sg" {
  name        = "alb-ext-sg"
  description = "ALB external"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS PORT"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP PORT"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "alb-ext-sg-${terraform.workspace}"
  }
}

resource "aws_security_group" "ec2-bastion-sg" {
  name        = "ec2-bastion-sg"
  description = "ec2 security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH PORT"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
#   ingress {
#     description = "HTTP PORT"
#     from_port   = 3306
#     to_port     = 3306
#     protocol    = "tcp"
#     cidr_blocks = [ var.cidr ]
#   }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "ec2-bastion-sg-${terraform.workspace}"
  }
}

resource "aws_security_group" "ec2-web-sg" {
  name        = "ec2-web-sg"
  description = "ec2 for web-instances"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP Port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [ aws_security_group.alb-ext-sg.id ]
  }
  ingress {
    description = "SSH Port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [ var.cidr ]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "ec2-web-sg-${terraform.workspace}"
  }
}