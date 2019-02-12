resource "aws_alb" "hello-world" {
  name            = "hello-world"
  subnets         = ["${data.terraform_remote_state.core.public_subnet_a_id}","${data.terraform_remote_state.core.public_subnet_b_id}"]
  security_groups = ["${data.terraform_remote_state.core.web_alb_sg_id}"]
}

resource "aws_alb_target_group" "hello-world" {
  name        = "hello-world"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${data.terraform_remote_state.core.vpc_id}"
  target_type = "ip"
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "hello-world" {
  load_balancer_arn = "${aws_alb.hello-world.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.hello-world.id}"
    type             = "forward"
  }
}