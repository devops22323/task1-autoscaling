provider "aws" {
  region = var.target_region
}

resource "aws_instance" "bastion_host" {
  ami                         = data.aws_ami.ubuntu.id
  key_name                    = var.key_pair
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.bastion_subnet1.id
  vpc_security_group_ids      = [aws_security_group.k8s_vpc_sg.id]
  user_data = file("./install.sh")

  tags = {
    Name = "bastion_subnet"
  }
}

// Create VPC
resource "aws_vpc" "k8s-vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "k8s_vpc"
  }
}

// Create Subnet 1
resource "aws_subnet" "bastion_subnet1" {
  vpc_id                  = aws_vpc.k8s-vpc.id
  cidr_block              = var.subnet1_cidr
  availability_zone       = var.subnet1_az
  map_public_ip_on_launch = true

  tags = {
    Name = "bastion_subnet-1"
  }
}

// Create Subnet 2
resource "aws_subnet" "bastion_subnet2" {
  vpc_id                  = aws_vpc.k8s-vpc.id
  cidr_block              = var.subnet2_cidr
  availability_zone       = var.subnet2_az
  map_public_ip_on_launch = true

  tags = {
    Name = "bastion_subnet2"
  }
}

// Create Internet Gateway

resource "aws_internet_gateway" "k8s_igw" {
  vpc_id = aws_vpc.k8s-vpc.id

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
resource "aws_route_table_association" "rt_association-1" {
  subnet_id = aws_subnet.bastion_subnet1.id

  route_table_id = aws_route_table.public_rt.id
}
// associate subnet with route table 
resource "aws_route_table_association" "rt_association" {
  subnet_id = aws_subnet.bastion_subnet2.id

  route_table_id = aws_route_table.public_rt.id
}

// create a security group
resource "aws_security_group" "k8s_vpc_sg" {
  name = "k8s_vpc_sg"

  vpc_id = aws_vpc.k8s-vpc.id

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
    Name = "allow_ssh"
  }
}

module "sgs" {
  source = "./sg_eks"
  vpc_id = aws_vpc.k8s-vpc.id
}

module "eks" {
  source     = "./eks"
  sg_ids     = module.sgs.security_group_public
  vpc_id     = aws_vpc.k8s-vpc.id
  subnet_ids = [aws_subnet.bastion_subnet1.id, aws_subnet.bastion_subnet2.id]
  key_pair   = var.key_pair
}