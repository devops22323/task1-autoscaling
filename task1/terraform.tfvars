instance_type = "t3.micro"
instance_keypair = "laptop_key"
target_region = "ap-southeast-4"
vpc_cidr_range = "10.0.0.0/16"
public_subnets_cidr = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24" ]
private_subnets_cidr = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24" ]
azs =  ["ap-southeast-4a", "ap-southeast-4b", "ap-southeast-4c"]