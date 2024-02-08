# main.tf

# Provider configuration
provider "aws" {
  region = "us-east-2"  # Change this to your desired AWS region
}

# VPC configuration
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "MyVPC"
  }
}

# Subnet configuration (optional, but recommended for practical use)
resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2a"  # Change this to your desired availability zone
  map_public_ip_on_launch = true

  tags = {
    Name = "MySubnet"
  }
}

# Security Group configuration
resource "aws_security_group" "my_security_group" {
  name        = "MySecurityGroup"
  description = "Allow incoming SSH and HTTP traffic"

  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MySecurityGroup"
  }
}

# EC2 Instance configuration
resource "aws_instance" "my_ec2_instance" {
  ami           = "ami-09694bfab577e90b0"  # Replace with the AMI ID of your desired Linux image
  instance_type = "t2.micro"               # Replace with your desired instance type
  key_name      = "testkey"                # Replace with your key pair name

  subnet_id = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  
  tags = {
    Name = "MyEC2Instance"
  }
}

# Internet Gateway configuration
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "MyInternetGateway"
  }
}

# Route Table configuration
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "MyRouteTable"
  }
}

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "my_route_table_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}
