#Input Variables

# AWS Region
variable "target_region" {
    type = string
    description = "AWS Region in which resourced are to be Created"
  
}

# VPC CIDR 
variable "vpc_cidr_range" {
    type = string
    description = "CIDR of VPC"
  
}


# Public Subnets
variable "public_subnets_cidr" {
    type = list(string)
    description = "These are public subnets"
  
}

# Private Subnets
variable "private_subnets_cidr" {
    type = list(string)
    description = "These are private subnets"
  
}

# Availability Zones
variable "azs" {
 type        = list(string)
 description = "Availability Zones"
 
}

# EC2 Instance Type
variable "instance_type" {
    type = string
    description = "EC2 Instance Type"
  
}

# EC2 Instance Key Pair
variable "instance_keypair" {
    type = string
    description = "EC2 Instance Type"
  
}


