provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    key    = "hello-world.tfstate"
    region = "us-west-2"
  }
}

resource "aws_ecr_repository" "helloworld" {
  name = "helloworld"
}