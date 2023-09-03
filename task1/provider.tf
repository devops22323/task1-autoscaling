terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
      random = {
      source = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.target_region
}

# Create Random Pet Resource
resource "random_pet" "mypet" {
  length = 2
}

