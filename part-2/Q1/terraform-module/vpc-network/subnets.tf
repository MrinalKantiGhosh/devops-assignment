data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "application_private_subnet" {
  count = length(var.private_subnets)

  vpc_id = aws_vpc.application_vpc.id
  cidr_block = var.private_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[0]
  
  tags = {
    type = "application_private_subnet-${count.index}"
  }
}

resource "aws_subnet" "application_public_subnet" {
  count = length(var.public_subnets)

  vpc_id = aws_vpc.application_vpc.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    type = "application_public_subnet-${count.index}"
  }
}

resource "aws_route_table_association" "public_rt_association" {
  count = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  subnet_id      = element(aws_subnet.application_public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_rt[0].id
}


