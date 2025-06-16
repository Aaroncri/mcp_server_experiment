resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id # This attaches my IGW to the main VPC created in 'vpc.tf'

  tags = {
    Name = "Netsec-Main-IGW" # Name that will show up in AWS console
  }
}

# Allocate an Elastic IP for the NAT gateway
resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
    Name = "langflow-nat-eip"
  }
}

# Create the NAT gateway in the public subnet
resource "aws_nat_gateway" "langflow_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.main-public.id

  tags = {
    Name = "langflow-nat-gateway"
  }
}
