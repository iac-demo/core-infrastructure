output "web_alb_sg_id" {
  value = "${aws_security_group.web_alb.id}"
}

output "web_ecs_sg_id" {
  value = "${aws_security_group.web_ecs.id}"
}

output "vpc_id" {
  value = "${aws_vpc.iacdemo_vpc.id}"
}

output "public_subnet_a_id" {
  value = "${aws_subnet.us-west-2a-public.id}"
}

output "public_subnet_b_id" {
  value = "${aws_subnet.us-west-2b-public.id}"
}

output "ecs_execution_role_arn" {
  value = "${aws_iam_role.ecs_task.arn}"
}

output "ecs_cluster_id" {
  value = "${aws_ecs_cluster.main.id}"
}