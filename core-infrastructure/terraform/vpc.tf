provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "iacdemo_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.iacdemo_vpc.id}"
}

resource "aws_subnet" "us-west-2a-public" {
  vpc_id = "${aws_vpc.iacdemo_vpc.id}"

  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "us-west-2b-public" {
  vpc_id = "${aws_vpc.iacdemo_vpc.id}"

  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-2b"
}


resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.iacdemo_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }
}

resource "aws_route_table_association" "us-west-2a-public" {
  subnet_id = "${aws_subnet.us-west-2a-public.id}"
  route_table_id = "${aws_route_table.main.id}"
}

resource "aws_route_table_association" "us-west-2b-public" {
  subnet_id = "${aws_subnet.us-west-2b-public.id}"
  route_table_id = "${aws_route_table.main.id}"
}


terraform {
  backend "s3" {
    key    = "iacdemo.tfstate"
    region = "us-west-2"
  }
}