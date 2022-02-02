provider "aws" {
  region = "us-east-2"
  access_key = "XXXXXX"
  secret_key = "XXXXXX"
}

variable "vpc-cidr-block" {
  description= "vpc cidr block"
  default = "10.0.0.0/16"
  type = string
}

variable "environment" {
  description= "deployment environment"
}

resource "aws_vpc" "dev-vpc" {
  cidr_block = var.vpc-cidr-block
  tags = {
      Name : var.environment
  }
}

variable "subnet-cidr-block" {
  description= "subnet cidr block"
}

resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.dev-vpc.id
  cidr_block = var.subnet-cidr-block
  availability_zone = "us-east-2a"
  tags = {
      Name : "dev-subnet-1"
  }
}

data "aws_vpc" "existing-vpc" {
  default = true # Default vpc
}

resource "aws_subnet" "dev-subnet-2" {
  vpc_id = data.aws_vpc.existing-vpc.id
  cidr_block = "172.31.48.0/20"
  availability_zone = "us-east-2a"
  tags = {
      Name : "subnet-2-default"
  }
}

output "dev-vpc-id" {
  value = aws_vpc.dev-vpc.id
}

output "dev-subnet-1-id" {
  value = aws_subnet.dev-subnet-1.id
}