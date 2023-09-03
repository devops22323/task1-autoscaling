provider "aws" {
  region = var.target_region
}

resource "aws_instance" "bastion_host" {
 ami = var.os_name
 key_name = var.key_pair
 instance_type  = var.instance_type
 associate_public_ip_address = true
subnet_id = aws_subnet.bastion_subnet.id
vpc_security_group_ids = [aws_security_group.demo-vpc-sg.id]
}

// Create VPC
resource "aws_vpc" "k8s-vpc" {
  cidr_block = var.vpc_cidr
}

// Create Subnet
resource "aws_subnet" "bastion_subnet" {
  vpc_id     = aws_vpc.k8s-vpc.id
  cidr_block = var.subnet1_cidr
  availability_zone = var.subnet_az

  tags = {
    Name = "demo_subnet"
  }
}

// Create Internet Gateway

resource "aws_internet_gateway" "k8s_igw" {
  vpc_id = aws_vpc.k8s-vpc

  tags = {
    Name = "k8s_igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.k8s-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s_igw.id
  }
  tags = {
    Name = "public_rt"
  }
}

// associate subnet with route table 
resource "aws_route_table_association" "public_rt_association" {
  subnet_id      = aws_subnet.bastion_subnet.id

  route_table_id = aws_route_table.public_rt.id
}
// create a security group 

resource "aws_security_group" "k8s_vpc_sg" {
  name        = "k8s_vpc_sg"
 
  vpc_id      = aws_vpc.k8s-vpc.id

  ingress {

    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

