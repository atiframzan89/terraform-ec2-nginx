vpc = {
    name = "vpc-dev"
    cidr = "11.0.0.0/16"
    public_subnet                   = ["11.0.1.0/24", "11.0.2.0/24", "11.0.3.0/24" ]
    private_subnet                  = ["11.0.4.0/24", "11.0.5.0/24", "11.0.6.0/24" ]
}
region                              = "us-west-2"
ami_id                              = "ami-03d5c68bab01f3496" # ubuntu us-west-2 ami code
root_volume_size                    = "10" # size in GB
root_volume_type                    = "gp2"

ec2-instance = {
    
    ec2-web-1 = {
    name                            = "ec2-web-1"
    instance_type                   = "t2.micro"
    associate_public_ip_address     = "false"
    key_pair                        = "atif-ncloud-oregon" 
    
    },
    ec2-web-2 = {
    name                            = "ec2-web-2"
    instance_type                   = "t2.micro"
    associate_public_ip_address     = "false"
    key_pair                        = "atif-ncloud-oregon" 
    
    }
}

ec2-bastion = {
    name                            = "ec2-bastion"
    instance_type                   = "t2.micro"
    associate_public_ip_address     = "true"
    key_pair                        = "atif-ncloud-oregon" 
    
}