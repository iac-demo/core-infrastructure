provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    key    = "hello-world.tfstate"
    region = "us-west-2"
  }
}

variable "corebucket" {
  default = "iacdemo"
}

data "terraform_remote_state" "core" {
  backend = "s3"
  config {
    key    = "iacdemo.tfstate"
    region = "us-west-2"
    bucket = "${var.corebucket}"
  }
}



