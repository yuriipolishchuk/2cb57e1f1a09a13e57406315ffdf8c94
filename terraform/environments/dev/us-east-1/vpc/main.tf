terraform {
  backend "s3" {
    bucket         = "terraform-state.your-org.tld"
    key            = "vpc"
    region         = "us-east-1"
    dynamodb_table = "terraform_lock"
  }
}

variable "aws_profile" {
}

provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = var.aws_profile
  version                 = "~> 2.18.0"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "v2.7.0"

  name = "dev-vpc"
  cidr = "10.0.0.0/16"

  azs = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c",
  ]

  private_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
  ]

  public_subnets = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24",
  ]

  enable_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

