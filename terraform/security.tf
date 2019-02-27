resource "aws_security_group" "web_alb" {
  name = "web_alb"
  description = "Allow incoming HTTP connections to ALB."

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.iacdemo_vpc.id}"
}

resource "aws_security_group" "web_ecs" {
  name        = "web_ecs"
  description = "allow inbound access from the ALB only"
  vpc_id      = "${aws_vpc.iacdemo_vpc.id}"

  ingress {
    protocol        = "tcp"
    from_port       = "8080"
    to_port         = "8080"
    security_groups = ["${aws_security_group.web_alb.id}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
