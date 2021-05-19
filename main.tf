module "vpc" {
    source                  = "./modules/vpc"
    vpc                     = var.vpc
    az                      = data.aws_availability_zones.available.names
}

module "sg" {

  source                    = "./modules/sg"
  vpc_id                    = module.vpc.vpc_id
  cidr                      = var.vpc.cidr 
  
 }

module "ec2-web-1" {
  source                    = "./modules/ec2"
  subnet_id                 =  module.vpc.private_subnet_1
  ec2-instance              = var.ec2-instance.ec2-web-1
  ec2-sg                    = [ module.sg.ec2-web-sg ]
  ami_id                    = var.ami_id 
  root_volume_size          = var.root_volume_size
  root_volume_type          = var.root_volume_type
  }
module "ec2-web-2" {
  source                    = "./modules/ec2"
  subnet_id                 = module.vpc.private_subnet_2
  ec2-instance              = var.ec2-instance.ec2-web-2
  ec2-sg                    = [ module.sg.ec2-web-sg ]
  ami_id                    = var.ami_id
  root_volume_size          = var.root_volume_size
  root_volume_type          = var.root_volume_type
  
  }

module "ec2-bastion" {
  source                    = "./modules/ec2-bastion"
  subnet_id                 = module.vpc.public_subnet_1
  ec2-instance              = var.ec2-bastion
  ec2-sg                    = [ module.sg.ec2-bastion-sg ]
  ami_id                    = var.ami_id
  
  }

module "alb" {
  source                    = "./modules/alb"
  alb-ext-sg                = [ module.sg.alb-ext-sg ]
  public_subnet             = [ module.vpc.public_subnet_1, module.vpc.public_subnet_2 ]
  private_subnet            = [ module.vpc.private_subnet_1, module.vpc.private_subnet_2 ]
  vpc_id                    = module.vpc.vpc_id
  az                        = data.aws_availability_zones.available.names
  ec2-web-1                 = module.ec2-web-1.ec2-instance-id
  ec2-web-2                 = module.ec2-web-2.ec2-instance-id
  depends_on                = [ module.ec2-web-1, module.ec2-web-2 ]
  
}
