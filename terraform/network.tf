# Internet Gateway (public internet access)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "main-igw" }
}

# Public route table -> IGW
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "public-rt" }
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public_assoc_1" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}

# NAT Gateway for private subnets (so EC2 can yum/pip install)
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id
  depends_on    = [aws_internet_gateway.igw]
  tags = { Name = "main-nat" }
}

# Private route table -> NAT
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = { Name = "private-rt" }
}

# Associate private APP subnets with private route table (DB stays private, no NAT needed)
resource "aws_route_table_association" "private_app_assoc_1" {
  subnet_id      = aws_subnet.private_app.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_app_assoc_2" {
  subnet_id      = aws_subnet.private_app_2.id
  route_table_id = aws_route_table.private_rt.id
}
