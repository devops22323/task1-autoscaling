variable "target_region" {
  type        = string
  description = "Region for our Infra"

}

variable "key_pair" {
  type        = string
  description = "Key"

}

variable "instance_type" {
  type        = string
  description = "Ec2 Instance Type"

}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR Range"

}

variable "subnet1_cidr" {
  type        = string
  description = "CIDR of subnet-1"

}

variable "subnet2_cidr" {
  type        = string
  description = "CIDR of subnet-2"

}

variable "subnet1_az" {
  type        = string
  description = "Availability Zone of Subnet"

}

variable "subnet2_az" {
  type        = string
  description = "Availability Zone of Subnet"

}