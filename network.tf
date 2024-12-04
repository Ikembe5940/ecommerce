########################################################
### NETWORKING ###
#######################################################

# VPC
resource "aws_vpc" "VPC-Jenkins-JavaApp-CICD" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
  Name = "VPC-Jenkins-JavaApp-CICD" 
  }
}

# Public Subnet
resource "aws_subnet" "Public-Subnet-Jenkins-JavaApp-CICD" {
  vpc_id                  = aws_vpc.VPC-Jenkins-JavaApp-CICD.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true" # This is what makes it a public subnet
  availability_zone       = "${var.AVAILABLE_REGIONS[var.AWS_REGIONS_INDEX]}a"
  tags = {
    Name = "Public-Subnet-Jenkins"
  }
}

# Private Subnet
resource "aws_subnet" "Private-Subnet-Jenkins-JavaApp-CICD" {
  vpc_id            = aws_vpc.VPC-Jenkins-JavaApp-CICD.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.AVAILABLE_REGIONS[var.AWS_REGIONS_INDEX]}a"
  tags = {
    Name = "Private-Subnet-Jenkins"
  }
}

# Add internet gateway
resource "aws_internet_gateway" "Jenkins-JavaApp-CICD-IGW" {
  vpc_id = aws_vpc.VPC-Jenkins-JavaApp-CICD.id
  tags = {
    Name = "Jenkins-JavaApp-CICD-IGW"
  }
}

# Public routes
resource "aws_route_table" "Jenkins-JavaApp-CICD-Rublic-CRT" {
  vpc_id = aws_vpc.VPC-Jenkins-JavaApp-CICD.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Jenkins-JavaApp-CICD-IGW.id
  }

  tags = {
    Name = "Jenkins-JavaApp-CICD-Rublic-CRT"
  }
}

# PUBLIC ROUTE ASSOCIATION
resource "aws_route_table_association" "Jenkins-JavaApp-CICD-CRTA-Public-Subnet" {
  subnet_id      = aws_subnet.Public-Subnet-Jenkins-JavaApp-CICD.id
  route_table_id = aws_route_table.Jenkins-JavaApp-CICD-Rublic-CRT.id
}

