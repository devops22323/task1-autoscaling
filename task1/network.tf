# Creating custom VPC
resource "aws_vpc" "ntier" {
    cidr_block = var.vpc_cidr_range
    enable_dns_hostnames = true
    enable_dns_support   = true
    tags = {
    "Name" = "Ntier-VPC"
  }
  
}

### Creating Public Subnets
resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnets_cidr)
  vpc_id            = aws_vpc.ntier.id
  cidr_block        = element(var.public_subnets_cidr, count.index)
  availability_zone = element(var.azs, count.index)
  map_public_ip_on_launch = true
 
  tags = {
   Name = "Public Subnet - ${count.index + 1}"
 }
}


### Creating Private Subnets
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnets_cidr)
  vpc_id            = aws_vpc.ntier.id
  cidr_block        = element(var.private_subnets_cidr, count.index)
  availability_zone = element(var.azs, count.index)
 
  tags = {
   Name = "Private Subnet - ${count.index + 1}"
 }
}

### Creating an IGW and attach to VPC
resource "aws_internet_gateway" "ntier_igw" {
  vpc_id = aws_vpc.ntier.id
  tags = {
    Name = "Ntier-IGW"
  }
}

# Create a custom route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.ntier.id 

  # Define route entries
  route {
    cidr_block = "0.0.0.0/0"  
    gateway_id = aws_internet_gateway.ntier_igw.id
  }
  tags = {
    Name = "Ntier-Public-rt"
  }
}

# Associate the custom route table with a subnet
resource "aws_route_table_association" "subnet_association" {
  count               = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}


### Creating a SG for Webservers
# Create Security Group - Web Traffic
resource "aws_security_group" "web-sg" {
  name        = "web-sg"
  vpc_id = aws_vpc.ntier.id
  ingress {
    description = "Allow Port 22"
    from_port   = local.ssh_port
    to_port     = local.ssh_port
    protocol    = local.tcp
    cidr_blocks = [local.any_where]
  }
  ingress {
    description = "Allow Port 80"
    from_port   = local.http_port
    to_port     = local.http_port
    protocol    = local.tcp
    cidr_blocks = [local.any_where]
  }
  ingress {
    description = "Allow Port 443"
    from_port   = local.https_port
    to_port     = local.https_port
    protocol    = local.tcp
    cidr_blocks = [local.any_where]
  }  
  egress {
    description = "Allow all ip and ports outbound"    
    from_port   = local.all_ports
    to_port     = local.all_ports
    protocol    = local.any_protocol
    cidr_blocks = [local.any_where]
  }

  tags = {
    Name = "web-sg"
  }
}



