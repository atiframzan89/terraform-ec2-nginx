# VPC main.tf file

resource "aws_vpc" "atif-vpc" {
    cidr_block = var.vpc.cidr
    tags = {
      "Name" = "atif-vpc-${terraform.workspace}"
    }
}

resource "aws_subnet" "public_subnet" {
    count = length(var.vpc.public_subnet)
    vpc_id = aws_vpc.atif-vpc.id
    cidr_block = element(var.vpc.public_subnet, count.index)
    availability_zone = element(var.az, count.index)
    depends_on = [ aws_vpc.atif-vpc ]

    
    tags = {
      "Name" = "public_subnet-${terraform.workspace}-${count.index}"
    }
}

resource "aws_subnet" "private_subnet" {
    count = length(var.vpc.private_subnet)
    
    vpc_id = aws_vpc.atif-vpc.id
    cidr_block = element(var.vpc.private_subnet, count.index)
    availability_zone = element(var.az, count.index)
    depends_on = [ aws_vpc.atif-vpc ]

    
    tags = {
      "Name" = "private_subnet-${terraform.workspace}-${count.index}"
    }
}

resource "aws_internet_gateway" "atif-igw" {
    vpc_id = aws_vpc.atif-vpc.id
    tags = {
      "Name" = "atif-igw-${terraform.workspace}"
    }
 
}


resource "aws_route_table" "private_rt_1" {
    vpc_id = aws_vpc.atif-vpc.id
    depends_on = [ aws_nat_gateway.atif-igw ]
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.atif-igw.id 
    }
    tags = {
      "Name" = "private_rt_${terraform.workspace}-1"
    }
}

resource "aws_route_table" "public_rt_1" {
    vpc_id = aws_vpc.atif-vpc.id
    depends_on = [ aws_internet_gateway.atif-igw ]
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.atif-igw.id
     } 
    tags = {
      "Name" = "public_rt_${terraform.workspace}-1"
    }
}

resource "aws_route_table_association" "public_rt_1_association" {
  count = length(var.vpc.public_subnet)
  subnet_id = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt_1.id
}

resource "aws_route_table_association" "private_rt_1_association" {
  count = length(var.vpc.private_subnet)
  subnet_id = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt_1.id
}

resource "aws_nat_gateway" "atif-igw" {
  allocation_id = aws_eip.atif-eip.id
  subnet_id = aws_subnet.public_subnet[0].id
  depends_on = [ aws_internet_gateway.atif-igw, aws_eip.atif-eip ]
  tags = {
    "Name" = "atif-igw-${terraform.workspace}"
  }
  
}

resource "aws_eip" "atif-eip" {
    tags = {
      "Name" = "atif-eip-${terraform.workspace}"
    }
  
}