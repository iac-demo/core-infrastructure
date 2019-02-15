variable "service_name" {}
variable "core_bucket" {}

data "terraform_remote_state" "core" {
  backend = "s3"
  config {
    key    = "iacdemo.tfstate"
    region = "us-west-2"
    bucket = "${var.core_bucket}"
  }
}

resource "aws_alb" "service" {
  name            = "${var.service_name}"
  subnets         = ["${data.terraform_remote_state.core.public_subnet_a_id}","${data.terraform_remote_state.core.public_subnet_b_id}"]
  security_groups = ["${data.terraform_remote_state.core.web_alb_sg_id}"]
}

resource "aws_alb_target_group" "service" {
  name        = "${var.service_name}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${data.terraform_remote_state.core.vpc_id}"
  target_type = "ip"
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "service" {
  load_balancer_arn = "${aws_alb.service.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.service.id}"
    type             = "forward"
  }
}