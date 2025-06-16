resource "aws_vpc" "main" {
  cidr_block = var.main_vpc_cidr_block

  tags = {
    Name = "langflow-vpc"
  }
}

#########################################################
###############    Public Subnet   ######################
#########################################################

resource "aws_subnet" "main-public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_langflow_subnet_cidr_block
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "langflow-public-subnet"
  }
}

#########################################################
###############    Private Subnet   #####################
#########################################################

resource "aws_subnet" "main-private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_langflow_subnet_cidr_block
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "langflow-private-subnet"
  }
}