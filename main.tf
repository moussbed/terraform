provider "aws" {
  region = "us-east-2"
  access_key = "XXXXXX"
  secret_key = "XXXXXX"
}

variable "cidr_blocks" {
  description= "vpc and subnets cidr block"
  type = list(object({
      cidr_block : string
      name : string
  }))
}


resource "aws_vpc" "dev-vpc" {
  cidr_block = var.cidr_blocks[0].cidr_block
  tags = {
      Name : var.cidr_blocks[0].name
  }
}

resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.dev-vpc.id
  cidr_block = var.cidr_blocks[1].cidr_block
  availability_zone = "us-east-2a"
  tags = {
      Name : var.cidr_blocks[1].name
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