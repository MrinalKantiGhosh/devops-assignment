resource "aws_internet_gateway" "internet-gw" {
  count = length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.application_vpc.id
}

resource "aws_route_table" "public_rt" {
  count = length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.application_vpc.id

  tags = {
    type = "public_route_table"
  }
}

resource "aws_route" "public_internet_gateway" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public_rt[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet-gw[0].id

  timeouts {
    create = "5m"
  }
}