resource "aws_ecr_repository" "helloworld" {
  name = "helloworld"
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = "AWSServiceRoleForECS"
}

resource "aws_ecs_cluster" "main" {
  name = "main-ecs-cluster"
}
