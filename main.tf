provider "aws" {
  region = "us-east-2"
}
# Variables
variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "availability_zone" {}
variable "env_prefix" {}
variable "my_ip" {}
variable "instance_type" {}
variable "public_key_location" {}


# VPC (Virtual Private Cloud)
resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
      Name : "${var.env_prefix}-vpc"
  }
}

# Subnet
resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.availability_zone
  tags = {
      Name : "${var.env_prefix}-subnet-1"
  }
}

# Internet Gateway (resource responsible for communication with the outside)
resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id

  tags = {
       Name: "${var.env_prefix}-igw"
  }
}

# Use Default Route Table and add it external communication route
resource "aws_default_route_table" "myapp-main-rtb" {
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id

  # Define external communication
  route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.myapp-igw.id 
  }

  tags = {
       Name: "${var.env_prefix}-rtb"
  }
}

# Use Default Security Group
resource "aws_default_security_group" "myapp-default-sg" {
  vpc_id = aws_vpc.myapp-vpc.id

  # incoming traffic 
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = [var.my_ip]
  }
  ingress {
      from_port = 8080
      to_port = 8080
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  # outgoing traffic 
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      prefix_list_ids = []
  }

  tags = {
       Name: "${var.env_prefix}-default-sg"
  }
}

# Query the lastest image of linux Amazon Machine Image(AMI)
data "aws_ami" "latest-linux-amazon-machine-image" {
  most_recent = true
  owners = ["137112412989"]
  filter {
    name = "name"
    values = ["amzn2-ami-kernel-*-x86_64-gp2"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}
output "aws_ami_id" {
  value = data.aws_ami.latest-linux-amazon-machine-image.id
}

# SSH Key Pair 
resource "aws_key_pair" "myapp-ssh-key-pair" {
 key_name = "server-myapp-key"
 public_key = "${file(var.public_key_location)}"
}

# EC2 (Elastic Compute Cloud)
resource "aws_instance" "myapp-server" {
   # Required
   ami = data.aws_ami.latest-linux-amazon-machine-image.id
   instance_type = var.instance_type

   #Optional
   subnet_id = aws_subnet.myapp-subnet-1.id
   vpc_security_group_ids = [aws_default_security_group.myapp-default-sg.id]
   availability_zone = var.availability_zone

   associate_public_ip_address = true
   key_name = aws_key_pair.myapp-ssh-key-pair.key_name

   tags = {
       Name: "${var.env_prefix}-server"
   }
}

output "ec2_public_ip" {
  value = aws_instance.myapp-server.public_ip
}

