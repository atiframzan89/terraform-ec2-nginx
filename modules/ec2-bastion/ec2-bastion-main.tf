resource "aws_instance" "ec2_instance" {
  ami           = var.ami_id
  instance_type = var.ec2-instance.instance_type
  subnet_id = var.subnet_id
  security_groups = var.ec2-sg
  key_name = var.ec2-instance.key_pair
  associate_public_ip_address = var.ec2-instance.associate_public_ip_address

  
  tags = {
    "Name" = "${var.ec2-instance.name}-${terraform.workspace}"
  }
}