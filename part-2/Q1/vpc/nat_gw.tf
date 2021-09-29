resource "aws_eip" "nat_eip" {
  count = var.enable_nat_gateway ? 1 : 0
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  count = var.enable_nat_gateway ? 1 : 0

  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = aws_subnet.application_public_subnet[0].id

  tags = {
    Name = "Public_Nat_GW"
  }

  depends_on = [aws_internet_gateway.internet_gw]
}

resource "aws_route_table" "private_rt" {
  count = length(var.private_subnets) > 0 ? 1 : 0
  
  vpc_id = aws_vpc.application_vpc.id

  tags = {
    type = "private_route_table"
  }
}

resource "aws_route" "private_subnet_nat_gateway" {
  count = length(var.private_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.private_rt[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gw[0].id

  timeouts {
    create = "5m"
  }
}