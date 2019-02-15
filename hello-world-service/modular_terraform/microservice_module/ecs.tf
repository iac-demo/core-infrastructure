variable "docker_image" {}


resource "aws_ecs_task_definition" "service" {
  family                   = "${var.service_name}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "${data.terraform_remote_state.core.ecs_execution_role_arn}"
  cpu                      = "256" // 0.25 vCPU
  memory                   = "512" // 512 MB

  container_definitions = <<DEFINITION
[
  {
    "cpu": 256,
    "memory": 512,
    "image": "${var.docker_image}",
    "name": "${var.service_name}",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "service" {
  name            = "${var.service_name}"
  cluster         = "${data.terraform_remote_state.core.ecs_cluster_id}"
  task_definition = "${aws_ecs_task_definition.service.arn}"
  desired_count   = "2"
  launch_type     = "FARGATE"


  network_configuration {
    security_groups = ["${data.terraform_remote_state.core.web_ecs_sg_id}"]
    subnets         = ["${data.terraform_remote_state.core.public_subnet_a_id}","${data.terraform_remote_state.core.public_subnet_b_id}"]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.service.id}"
    container_name   = "${var.service_name}"
    container_port   = "8080"
  }

  depends_on = [
    "aws_alb_listener.service",
  ]
}