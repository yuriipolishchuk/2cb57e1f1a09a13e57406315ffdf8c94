data "aws_caller_identity" "this" {}

data "aws_ami" "this" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.ami_name}"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["${local.ami_owner}"]
}
