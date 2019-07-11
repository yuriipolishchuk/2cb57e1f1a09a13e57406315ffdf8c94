terraform {
  backend "s3" {
    bucket         = "terraform-state.your-org.tld"
    key            = "global"
    region         = "us-east-1"
    dynamodb_table = "terraform_lock"
  }
}

variable "aws_profile" {}

provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "${var.aws_profile}"
  version                 = "~> 2.18.0"
}

module "s3_bucket_tf_state" {
  source = "../../../modules/s3"

  bucket = "terraform-state.your-org.tld"
}

resource "aws_dynamodb_table" "tf_lock" {
  name           = "terraform_lock"
  hash_key       = "LockID"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "LockID"
    type = "S"
  }
}
