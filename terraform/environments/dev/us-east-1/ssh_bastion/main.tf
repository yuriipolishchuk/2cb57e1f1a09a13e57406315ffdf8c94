terraform {
  backend "s3" {
    bucket         = "terraform-state.your-org.tld"
    key            = "bastion"
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

module "bastion" {
  source = "../../../../modules/bastion"

  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDU/KczWEZQ87CHqUQQpt8AdNEyEsFjtprpyuYHtK7z2AfpKXL11yV9R/6/cL08ww5HTiE/ZOVyfrlJqFIsQzxAq4wQggwuwE1AhjQUpOKmfRLfpfZQhZVnDQSZ7xrVHaoQ0ROgdvgqnaFRaSGDZbVj1ldT1BYNqEdyhbwqqQXGoY+Oc6nrzThcGEbcS9d1T6C0jXqIEo2iNwBzInyD/bM785ue90Kppwfenwgg6temq49Pw2bEJnE+Od6JHErfVQCY3bNai5SljLTlELOTQ+9WSrUKaa21Q6WzI1QG6fnprMMDplp5NlRSxE3a6XDzSedu1VCUgwAZ7WcpvaI4fxmX yurii@mbp"

  vpc_id                 = "${data.terraform_remote_state.vpc.outputs.vpc_id}"
  private_subnet_ids     = "${data.terraform_remote_state.vpc.outputs.private_subnets}"
  public_subnet_ids      = "${data.terraform_remote_state.vpc.outputs.public_subnets}"
  elb_availability_zones = "${data.terraform_remote_state.vpc.outputs.azs}"

  instance_type = "t2.medium"

  tags = [
    {
      Name        = "bastion"
      Terraform   = "true"
      Environment = "dev"
    },
  ]
}
