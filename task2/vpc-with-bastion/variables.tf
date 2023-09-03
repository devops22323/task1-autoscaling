variable "target_region" {
    type = string
    description = "Region for our Infra"
    default = "ap-southeast-4"
}

variable "os_name" {
    type = string
    description = "AMI ID"
    default = "ami-09ba48996007c8b50"
}

variable "key_pair" {
    type = string
    description = "Key"
    default = "laptop_key"
}

variable "instance_type" {
    type = string
    description = "Ec2 Instance Type"
    default = "t3.micro"
}

variable "vpc_cidr" {
    type = string
    description = "VPC CIDR Range"
    default = "10.10.0.0/16"  
}

variable "subnet1_cidr" {
    type = string
    description = "CIDR of subnet1"
    default = "10.10.1.0/24"
  
}
variable "subnet_az" {
    type = string
    description = "Availability Zone of Subnet"
    default =  "ap-southeast-4a"  
}