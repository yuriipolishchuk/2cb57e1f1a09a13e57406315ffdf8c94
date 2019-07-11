locals {
  ami_owner = var.ami_owner == "" ? data.aws_caller_identity.this.account_id : var.ami_owner
}

resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = var.public_key
}

resource "aws_launch_configuration" "this" {
  name            = "bastion"
  image_id        = data.aws_ami.this.id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.this.key_name
  security_groups = [aws_security_group.ssh_bastion_sg.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  name_prefix          = "bastion-"
  max_size             = 1
  min_size             = 1
  launch_configuration = aws_launch_configuration.this.name
  vpc_zone_identifier  = var.private_subnet_ids
  force_delete         = true

  wait_for_capacity_timeout = "300s"
  health_check_grace_period = 600
  health_check_type         = "EC2"

  tags = [
    {
      key                 = "Name"
      value               = "bastion"
      propagate_at_launch = true
    },
    {
      key                 = "terraform"
      value               = "true"
      propagate_at_launch = true
    },
  ]

  load_balancers = [aws_elb.this.id]
}

resource "aws_elb" "this" {
  name = "bastion-elb"

  subnets                   = var.public_subnet_ids
  security_groups           = [aws_security_group.elb_ssh_bastion_sg.id]
  cross_zone_load_balancing = true

  health_check {
    target              = "TCP:22"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  listener {
    instance_port     = 22
    instance_protocol = "tcp"
    lb_port           = 22
    lb_protocol       = "tcp"
  }
}

