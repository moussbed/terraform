# Subnet
resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = var.vpc_id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.availability_zone
  tags = {
      Name : "${var.env_prefix}-subnet-1"
  }
}

# Internet Gateway (resource responsible for communication with the outside)
resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = var.vpc_id

  tags = {
       Name: "${var.env_prefix}-igw"
  }
}

# Use Default Route Table and add it external communication route
resource "aws_default_route_table" "myapp-main-rtb" {
  default_route_table_id = var.default_route_table_id

  # Define external communication
  route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.myapp-igw.id 
  }

  tags = {
       Name: "${var.env_prefix}-rtb"
  }
}
