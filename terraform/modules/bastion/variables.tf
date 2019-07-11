variable "vpc_id" {
  type    = "string"
  default = ""
}

# for ELB
variable "public_subnet_ids" {
  type    = "list"
  default = []
}

# for bastion instances
variable "private_subnet_ids" {
  type    = "list"
  default = []
}

variable "instance_type" {
  type    = "string"
  default = "t2.micro"
}

variable "ami_owner" {
  type    = "string"
  default = ""
}

variable "ami_name" {
  type    = "string"
  default = "bastion-*"
}

variable "tags" {
  type    = "list"
  default = [{}]
}

variable "public_key" {
  type    = "string"
  default = ""
}

variable "key_name" {
  type    = "string"
  default = "bastion"
}

variable "elb_availability_zones" {
  type    = "list"
  default = []
}

variable "elb_ingress_cidr_blocks" {
  type    = "list"
  default = ["0.0.0.0/0"]
}
