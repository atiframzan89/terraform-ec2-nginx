data "template_file" "userdata" {
  template = file("${path.module}/templates/userdata.sh")
  # vars = {
  #   private_ip = var.private_ip
  #   network_lb_dns_name = var.network_lb_dns_name

  # }
}
resource "aws_instance" "ec2_instance" {
  ami                         = var.ami_id
  instance_type               = var.ec2-instance.instance_type
  subnet_id                   = var.subnet_id
  security_groups             = var.ec2-sg
  key_name                    = var.ec2-instance.key_pair
  associate_public_ip_address = var.ec2-instance.associate_public_ip_address
  user_data = data.template_file.userdata.rendered
  root_block_device            {
                                  volume_type = var.root_volume_type
                                  volume_size = var.root_volume_size
                                }
  
  tags = {
    "Name" = "${var.ec2-instance.name}-${terraform.workspace}"
  }
}
